# Teaser web lawoss.app

- **Stav:** 🟢 beží na [lawoss.app](https://lawoss.app) · SK · CZ · EN
- **Repo:** [Omni-Legal-Products/lawoss-web](https://github.com/Omni-Legal-Products/lawoss-web) (private)
- **Založené:** 2026-08-28

Verejná tvár projektu. **Nie je to landing page so zoznamom funkcií** a zámerne neodhaľuje, čo appka vie —
ukazuje značku, tón a útržky rozhrania, aby sa to nedalo obkresliť.

## Os komunikácie

Nesľubujeme, že appka nahradí advokáta. Tým sa vymedzujeme voči marketingu, ktorý tvrdí opak.
Stavajú to advokáti pre advokátov a pre komunitu; dávame základ, na ktorom si kancelária postaví vlastné.
Bežné právne appky robia IT firmy s občasným feedbackom advokáta — my to remeslo robíme, takže vieme
od začiatku, ako to stavať.

Stránku nesú dva manifesty cez celú šírku:

> *„Nesľubujeme, že vás nahradíme."* · *„AI sa stane samozrejmosťou. Ide o to, kto ju bude držať."*

## Čo web preberá z tohto repa

| Čo | Odkiaľ | Ako |
|---|---|---|
| Tokeny (farby, tvar, typografia) | [`docs/design/design-system.md`](design/design-system.md) | prepísané do `site/src/styles/globals.css` |
| Zákazy §0 (žiadne karty s ikonkou, pills, eyebrows, glow) | [`docs/design/2026-08-23-dizajnovy-jazyk-lawoss.md`](design/2026-08-23-dizajnovy-jazyk-lawoss.md) | dodržané, overované `impeccable detect` |
| Vzory (register, pás lehôt, karta brány, pečať) | ten istý dokument, §3–§5 | prekreslené ako SVG schémy |
| Rendery a mockupy | `assets/brand/keyvisual-*.png`, `assets/brand/mockupy/` | natívne výrezy, žiadne zväčšovanie |
| Podklad pre wordmark | `assets/brand/loga-navrhy/11–14` | prekreslené do kriviek |

> [!IMPORTANT]
> **Zmena farby, radiusu alebo písma sa nerobí vo webe.** Robí sa tu, v dizajn systéme,
> a odtiaľ sa prenesie. Web a appka musia vyzerať ako jedna vec.

## Čo si web drží sám

- **Lettering wordmarku** — geometrická abeceda v krivkách (`design/lettering/lettering.py` v teaser repe).
  `A` bez priečnej čiary, kruhové `O`, `W` ako dve špicaté `V`. Žiadna závislosť na fonte.
  Toto je zatiaľ jediná hotová implementácia wordmarku a mala by sa prebrať aj do appky.
- **Marketingové texty** v troch jazykoch (`site/src/lib/i18n.ts`).
- **Favicon** — `A` bez priečky, zlatá na tmavom.

## Čo z toho patrí späť sem

- [ ] **wordmark ako lettering** — keď sa dorieši logo, krivky by mali skončiť v `assets/brand/`
      a v dizajn systéme §3b nahradiť poznámku o „pracovnej náhrade"
- [ ] **diagram Loop** (kruh rozhodnutia okolo spisu) — je to dobrá schéma OKF mechaniky,
      hodila by sa aj do dizajn systému §5

## Nasadenie a pošta

Podrobne v README teaser repa. V skratke: Dokploy compose `lawoss-web`, autoDeploy z `main`,
Traefik + Let's Encrypt, server `87.197.117.6` — ten istý stroj ako Stalwart.
Prihlášky z formulára chodia cez SMTP na `majo@lawoss.app`, doména má catch-all.
