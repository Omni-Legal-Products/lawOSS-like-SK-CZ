# Ako prispievať

> 📖 **Úplné pravidlá sú v [`AGENTS.md`](AGENTS.md)** — platia pre ľudí aj AI agentov. Tento súbor je len rýchly rozcestník, aby sme ich nemali na dvoch miestach.

## Rýchly štart

```bash
git clone https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ.git
cd lawOSS-like-SK-CZ
```

Potom si **prečítaj [`AGENTS.md`](AGENTS.md)** — je to jediný súbor, ktorý potrebuješ.
Ak používaš AI agenta (Claude Code, Codex…), načíta si ho sám (`CLAUDE.md` je naň symlink).

## Tri veci, ktoré ťa najskôr štvú, ak ich nevieš

1. **Vždy `git pull --no-rebase` pred pushom.** Nad repom beží bot, ktorý po každom pushi sám commitne aktualizáciu `README.md` — bez pullu ti push odmietne.
2. **Needituj AUTO sekcie v `README.md`** (medzi `<!-- AUTO:X -->`). Generujú sa automaticky, tvoje zmeny sa prepíšu.
3. **Väčšie veci cez branch + PR**, drobnosti priamo do `main`. Nikdy `--force`.

## Chcem navrhnúť funkciu

Netreba písať markdown ani robiť PR:

👉 **[Podaj návrh cez formulár](https://github.com/Omni-Legal-Products/lawOSS-like-SK-CZ/issues/new?template=feature-navrh.yml)**

Po prerokovaní ho prepíšeme do [`specs/`](specs/) a zapíšeme do [`specs/navrhy.md`](specs/navrhy.md) s tvojím menom.

## Kto sme

**MČ** Marián Čuprík · **MF** Martin Friedrich · **IR** Igor Ribár
Komunikácia: Telegram *MikeOSS (SLOVAKIA) + AI Frontier Labs*
