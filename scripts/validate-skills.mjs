#!/usr/bin/env node
/**
 * validate-skills.mjs: validátor skillov pre LAWOSS
 * (Omni-Legal-Products/lawOSS-like-SK-CZ)
 *
 * Použitie: node scripts/validate-skills.mjs [koreň-repa]
 * Čistý Node 20+, bez npm závislostí.
 *
 * Hľadá SKILL.md v tvare plugins/<plugin>/skills/<name>/SKILL.md
 * a skills/<name>/SKILL.md (rekurzívne pod plugins/ aj skills/).
 * CHYBY dávajú exit 1, VAROVANIA exit 0. Chybné použitie exit 2.
 */

import { readFileSync, readdirSync, existsSync, statSync } from "node:fs";
import { join, relative, sep } from "node:path";
import process from "node:process";

const SKIP_DIRS = new Set([".git", "node_modules"]);
const KEBAB = /^[a-z0-9]+(-[a-z0-9]+)*$/;
// Negatívne vymedzenie v description; pokrýva zadané reťazce
// "NEAKTIVUJ", "Neaktivuj", "Do not use", "not for" (case-insensitive).
const NEGATIVNE = [/neaktivuj/i, /do not use/i, /not for/i];
const MAX_DESC = 1024;
const JACCARD_PRAH = 0.5;
const MIN_TRIGGERS = 3;

// ---------------------------------------------------------------------------
// Prehľadanie stromu

function najdiSkillSubory(root) {
  const najdene = [];
  function walk(dir) {
    let entries;
    try {
      entries = readdirSync(dir, { withFileTypes: true });
    } catch {
      return; // nečitateľný adresár preskoč
    }
    for (const e of entries) {
      if (e.isDirectory()) {
        if (!SKIP_DIRS.has(e.name)) walk(join(dir, e.name));
      } else if (e.isFile() && e.name === "SKILL.md") {
        najdene.push(join(dir, e.name));
      }
    }
  }
  walk(root);
  // Filter na tvar cesty: prvý segment plugins alebo skills
  // a SKILL.md leží priamo v .../skills/<name>/.
  return najdene
    .filter((p) => {
      const seg = relative(root, p).split(sep);
      if (seg.length < 3) return false;
      if (seg[0] !== "plugins" && seg[0] !== "skills") return false;
      return seg[seg.length - 3] === "skills";
    })
    .sort();
}

// ---------------------------------------------------------------------------
// Mini YAML parser: ploché polia key: value, podpora blokových skalárov > a |
// a jednoduchých úvodzoviek. Vracia polia s číslom riadku pre report.

function parseFrontmatter(text) {
  const lines = text.replace(/^﻿/, "").split(/\r?\n/);
  if ((lines[0] ?? "").trim() !== "---") {
    return { ok: false, chyba: "chýbajúci frontmatter (súbor nezačína riadkom ---)", riadok: 1 };
  }
  let koniec = -1;
  for (let i = 1; i < lines.length; i++) {
    if (lines[i].trim() === "---") { koniec = i; break; }
  }
  if (koniec === -1) {
    return { ok: false, chyba: "neparsovateľný frontmatter (chýba uzatvárací ---)", riadok: 1 };
  }

  const polia = Object.create(null); // kluc -> { hodnota, riadok }
  for (let i = 1; i < koniec; i++) {
    const line = lines[i];
    if (line.trim() === "" || line.trim().startsWith("#")) continue;
    const m = line.match(/^([A-Za-z0-9_-]+):\s*(.*)$/);
    if (!m) {
      return {
        ok: false,
        chyba: `neparsovateľný riadok frontmatteru: "${line.trim().slice(0, 60)}"`,
        riadok: i + 1,
      };
    }
    const kluc = m[1];
    let hodnota = m[2].trim();
    const riadok = i + 1;

    if (/^[>|][+-]?$/.test(hodnota)) {
      // blokový skalár: pozbieraj nasledujúce odsadené alebo prázdne riadky
      const styl = hodnota[0];
      const buf = [];
      while (i + 1 < koniec && (lines[i + 1].trim() === "" || /^\s/.test(lines[i + 1]))) {
        i++;
        buf.push(lines[i].trim());
      }
      hodnota = buf.filter(Boolean).join(styl === ">" ? " " : "\n").trim();
    } else {
      const q = hodnota.match(/^(['"])([\s\S]*)\1$/);
      if (q) hodnota = q[2];
    }
    polia[kluc] = { hodnota, riadok };
  }

  return { ok: true, polia, telo: lines.slice(koniec + 1).join("\n") };
}

// ---------------------------------------------------------------------------
// Pomocné funkcie

function tokenizuj(text) {
  // lowercase, bez interpunkcie (unicode písmená a číslice ostávajú)
  return new Set(
    text.toLowerCase().replace(/[^\p{L}\p{N}]+/gu, " ").split(/\s+/).filter(Boolean)
  );
}

function jaccard(a, b) {
  if (a.size === 0 || b.size === 0) return 0;
  let prienik = 0;
  for (const t of a) if (b.has(t)) prienik++;
  return prienik / (a.size + b.size - prienik);
}

function najdiTriggersSubor(testsDir) {
  let entries;
  try {
    entries = readdirSync(testsDir, { withFileTypes: true });
  } catch {
    return null;
  }
  const subory = entries.filter((e) => e.isFile()).map((e) => e.name);
  if (subory.includes("triggers.md")) return join(testsDir, "triggers.md");
  const iny = subory.find((n) => n.toLowerCase().includes("trigger"));
  return iny ? join(testsDir, iny) : null;
}

function pocetAktivacnychViet(cesta) {
  const riadky = readFileSync(cesta, "utf8").split(/\r?\n/).map((r) => r.trim());
  // primárne počítame odrážky a číslované položky
  const odrazky = riadky.filter((r) => /^(-|\*|\d+[.)])\s+/.test(r)).length;
  if (odrazky > 0) return odrazky;
  // fallback: neprázdne riadky mimo nadpisov
  return riadky.filter((r) => r !== "" && !r.startsWith("#")).length;
}

// ---------------------------------------------------------------------------
// Hlavný beh

const root = process.argv[2] ?? ".";
if (!existsSync(root) || !statSync(root).isDirectory()) {
  console.error(`Koreň repa "${root}" neexistuje alebo nie je adresár.`);
  process.exit(2);
}

const subory = najdiSkillSubory(root);
const chyby = [];     // { subor, riadok, sprava }
const varovania = []; // { subor, riadok, sprava }  (riadok môže byť null)
const podlaMena = new Map(); // name -> [{ subor, riadok }]
const popisy = [];           // { name, subor, tokeny }

for (const abs of subory) {
  const rel = relative(root, abs).split(sep).join("/");
  const dirName = relative(root, abs).split(sep).at(-2);

  let text;
  try {
    text = readFileSync(abs, "utf8");
  } catch (e) {
    chyby.push({ subor: rel, riadok: 1, sprava: `súbor sa nedá prečítať (${e.message})` });
    continue;
  }

  const fm = parseFrontmatter(text);
  if (!fm.ok) {
    chyby.push({ subor: rel, riadok: fm.riadok, sprava: fm.chyba });
    continue;
  }

  const name = fm.polia.name;
  const description = fm.polia.description;

  // --- CHYBY ---
  if (!name || name.hodnota === "") {
    chyby.push({ subor: rel, riadok: 1, sprava: "chýbajúce povinné pole name" });
  } else {
    if (!KEBAB.test(name.hodnota)) {
      chyby.push({ subor: rel, riadok: name.riadok, sprava: `name "${name.hodnota}" nie je kebab-case` });
    }
    if (name.hodnota !== dirName) {
      chyby.push({
        subor: rel,
        riadok: name.riadok,
        sprava: `name "${name.hodnota}" sa nezhoduje s názvom adresára "${dirName}"`,
      });
    }
    if (!podlaMena.has(name.hodnota)) podlaMena.set(name.hodnota, []);
    podlaMena.get(name.hodnota).push({ subor: rel, riadok: name.riadok });
  }

  if (!description || description.hodnota === "") {
    chyby.push({ subor: rel, riadok: 1, sprava: "chýbajúce povinné pole description" });
  }

  if (fm.telo.trim() === "") {
    chyby.push({ subor: rel, riadok: 1, sprava: "prázdne telo pod frontmatterom" });
  }

  // --- VAROVANIA (len ak description existuje) ---
  if (description && description.hodnota !== "") {
    const d = description.hodnota;

    if (d.length > MAX_DESC) {
      varovania.push({
        subor: rel,
        riadok: description.riadok,
        sprava: `description má ${d.length} znakov (limit ${MAX_DESC})`,
      });
    }

    if (!NEGATIVNE.some((re) => re.test(d))) {
      varovania.push({
        subor: rel,
        riadok: description.riadok,
        sprava: 'description nemá negatívne vymedzenie ("NEAKTIVUJ" / "Do not use" / "not for")',
      });
    }

    // heuristika krokov postupu: "1." aj "2." v texte popisu
    if (/(^|\s)1\./.test(d) && /(^|\s)2\./.test(d)) {
      varovania.push({
        subor: rel,
        riadok: description.riadok,
        sprava: "description obsahuje číslované kroky postupu (patria do tela skillu)",
      });
    }

    popisy.push({ name: name ? name.hodnota : rel, subor: rel, tokeny: tokenizuj(d) });
  }

  // --- tests/ adresár a triggers ---
  const testsDir = join(abs, "..", "tests");
  if (!existsSync(testsDir)) {
    varovania.push({ subor: rel, riadok: null, sprava: "chýba tests/ adresár" });
  } else {
    const trg = najdiTriggersSubor(testsDir);
    if (!trg) {
      varovania.push({ subor: rel, riadok: null, sprava: "tests/ nemá triggers súbor" });
    } else {
      const n = pocetAktivacnychViet(trg);
      if (n < MIN_TRIGGERS) {
        varovania.push({
          subor: rel,
          riadok: null,
          sprava: `triggers súbor má len ${n} aktivačné vety (minimum ${MIN_TRIGGERS})`,
        });
      }
    }
  }
}

// --- duplicitné name naprieč repom ---
for (const [meno, vyskyty] of podlaMena) {
  if (vyskyty.length > 1) {
    for (const v of vyskyty) {
      const ostatne = vyskyty.filter((o) => o !== v).map((o) => o.subor).join(", ");
      chyby.push({ subor: v.subor, riadok: v.riadok, sprava: `duplicitné name "${meno}" (aj v: ${ostatne})` });
    }
  }
}

// --- podobnostná kolízia popisov (Jaccard nad prah) ---
for (let i = 0; i < popisy.length; i++) {
  for (let j = i + 1; j < popisy.length; j++) {
    const sim = jaccard(popisy[i].tokeny, popisy[j].tokeny);
    if (sim > JACCARD_PRAH) {
      varovania.push({
        subor: popisy[i].subor,
        riadok: null,
        sprava: `popisy skillov "${popisy[i].name}" a "${popisy[j].name}" sú podozrivo podobné (Jaccard ${sim.toFixed(2)} > ${JACCARD_PRAH})`,
      });
    }
  }
}

// ---------------------------------------------------------------------------
// Report

console.log("=== Validátor skillov LAWOSS ===");
console.log(`Koreň: ${root}`);
console.log(`Preskenované SKILL.md súbory: ${subory.length}`);

if (subory.length === 0) {
  console.log("Nenašiel sa žiadny SKILL.md pod plugins/ ani skills/.");
  process.exit(0);
}

console.log("");
console.log(`CHYBY: ${chyby.length}`);
for (const ch of chyby) {
  console.log(`  ${ch.subor}:${ch.riadok}  ${ch.sprava}`);
}

console.log("");
console.log(`VAROVANIA: ${varovania.length}`);
for (const v of varovania) {
  console.log(`  ${v.subor}${v.riadok ? ":" + v.riadok : ""}  ${v.sprava}`);
}

console.log("");
console.log(`Zhrnutie: ${subory.length} súborov, ${chyby.length} chýb, ${varovania.length} varovaní.`);
process.exit(chyby.length > 0 ? 1 : 0);
