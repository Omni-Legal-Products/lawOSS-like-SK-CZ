# Inventár MCP repozitárov

- **Kontrola:** 2026-08-12
- **Rozhodnutie:** [ADR 0008](../decisions/0008-sprava-mcp-repozitarov.md)
- **Rozsah:** 15 osobných upstreamov MČ určených na prípravu súkromných tímových kópií
- **Mimo rozsahu:** `HITL-Forms-MCP`, `SOI-MCP`

> [!IMPORTANT]
> Osobné repozitáre `originalmagneto/*` zostávajú zdrojom pravdy. Stav `čaká` znamená, že organizačná kópia sa ešte nesmie vytvoriť.

## Súhrn

| Osobný upstream | Commit `main` pri audite | Visibility | Fork | Licencia z GitHub API | Agent rules | Secret scan | Dokploy | Organizačný cieľ | Jurisdikcia | Brána |
|---|---|---:|---:|---|---|---|---|---|---|---|
| `kalkulacky-sk-MCP` | `9dc626c` | private | nie | neuvedená | chýbajú | bez nálezu | KALK-MCP, GitHub source neoverený | `mcp-kalkulacky-sk` | `slovakia` | čaká |
| `judikaty-mcp` | `eb51107` | private | nie | neuvedená | chýbajú | bez nálezu | judikaty-mcp, GitHub source neoverený | `mcp-judikaty-sk` | `slovakia` | čaká |
| `slov-lex-mcp-deploy` | `6b35fd9` | private | nie | `NOASSERTION` | chýbajú | iba placeholdery | Slov-lex-MCP, source type `github`, presný repo binding neoverený | `mcp-slovlex` | `slovakia` | čaká |
| `orsr-mcp` | `a9cf921` | private | nie | neuvedená | chýbajú | bez nálezu v aplikačnom kóde | ORSR-MC, GitHub source neoverený | `mcp-orsr` | `slovakia` | čaká |
| `RPO-MCP` | `52d0909` | private | nie | neuvedená | chýbajú | bez nálezu | RPO-MCP, GitHub source neoverený | `mcp-rpo` | `slovakia` | čaká |
| `RPVS-MCP` | `25269e8` | private | nie | neuvedená | chýbajú | bez nálezu | RPVS-MCP, GitHub source neoverený | `mcp-rpvs` | `slovakia` | čaká |
| `RUZ-MCP` | `1b36810` | private | nie | neuvedená | chýbajú | bez nálezu | RUZ-MCP, GitHub source neoverený | `mcp-ruz` | `slovakia` | čaká |
| `crz-mcp` | `7740803` | private | nie | MIT | chýbajú | iba placeholdery | CRZ-MCP, GitHub source neoverený | `mcp-crz` | `slovakia` | čaká |
| `FS-MCP` | `b76570d` | private | nie | neuvedená | chýbajú | bez nálezu | FS-MCP, GitHub source neoverený | `mcp-financna-sprava` | `slovakia` | čaká |
| `OV-MCP` | `118bff7` | private | nie | neuvedená | zhodné, neúplné | bez nálezu | OV-MCP, GitHub source neoverený | `mcp-obchodny-vestnik` | `slovakia` | čaká |
| `RU-MCP` | `1088718` | private | nie | neuvedená | zhodné, neúplné | bez nálezu | RU-MCP, GitHub source neoverený | `mcp-register-upadcov` | `slovakia` | čaká |
| `UVO-MCP` | `9a62185` | private | nie | neuvedená | zhodné | bez nálezu | UVO-MCP, GitHub source neoverený | `mcp-uvo` | `slovakia` | čaká |
| `DISQ-MCP` | `7e10452` | private | nie | neuvedená | chýbajú | bez nálezu | DISQ-MCP, GitHub source neoverený | `mcp-diskvalifikacie` | `slovakia` | čaká |
| `MCP-EURLEX-CELEX` | `0abfaca` | private | nie | neuvedená | chýbajú | bez nálezu | MCP-EURLEX, GitHub source neoverený | `mcp-eurlex` | `eu-law` | čaká |
| `cz-agents-mcp` | `32eea34` | public | áno | MIT | chýbajú | bez nálezu | CZ-Agents-MCP, source type `git`, presný repo binding neoverený | `mcp-cz-agents`, private mirror | `czechia` | čaká |

Všetky upstreamy majú default vetvu `main`, nie sú archivované a pri audite nemali nastavené GitHub topics.

## Lokálna verifikácia

| Upstream | Povinné offline minimum |
|---|---|
| `kalkulacky-sk-MCP` | `npm ci && npm run check && npm test && npm run build` |
| `judikaty-mcp` | `npm ci && npm run check && npm test && npm run build` |
| `slov-lex-mcp-deploy` | `npm ci && npm test && npm run build` |
| `orsr-mcp` | `npm ci && npm run typecheck && npm test && npm run build` |
| `RPO-MCP` | `npm ci && npm run typecheck && npm test && npm run build` |
| `RPVS-MCP` | `npm ci && npm run typecheck && npm test && npm run build` |
| `RUZ-MCP` | `npm ci && npm run typecheck && npm test && npm run build` |
| `crz-mcp` | `npm ci && npm test && npm run build` |
| `FS-MCP` | `npm ci && npm run typecheck && npm test && npm run build` |
| `OV-MCP` | `npm ci && npm run typecheck && npm test && npm run build` |
| `RU-MCP` | `npm ci && npm run typecheck && npm test && npm run build` |
| `UVO-MCP` | `npm ci && npm run typecheck && npm test && npm run build` |
| `DISQ-MCP` | `npm ci && npm run typecheck && npm test && npm run build` |
| `MCP-EURLEX-CELEX` | `npm ci && npm run typecheck && npm test && npm run build` |
| `cz-agents-mcp` | `npm ci && npm run lint && npm test && npm run build` |

Live, integračné, HTTP smoke a produkčné testy nie sú súčasťou offline minima. Spúšťajú sa iba po výslovnom pokyne a po kontrole požadovaných premenných prostredia.

## Dokploy mapovanie

| Projekt | Compose ID | Source type overený 2026-08-12 |
|---|---|---|
| KALK-MCP | `3pcFt-d1glXv_5CywVKgI` | nie |
| DISQ-MCP | `9SbEQ4qPFsG8xuTRQwRha` | nie |
| RU-MCP | `wHsQZn4cNDWdpdX7Uhqyg` | nie |
| UVO-MCP | `rVgU0mtwqhSM9yj4NYA_W` | nie |
| OV-MCP | `TxKBvma-mrZMcx3lt7zam` | nie |
| FS-MCP | `_sYnnIUbSDF5KIVQku-5n` | nie |
| RPVS-MCP | `evh-5_wt6NzB1uMX0QFv5` | nie |
| RPO-MCP | `i29-edyhRxzSlaX6C3vnZ` | nie |
| RUZ-MCP | `uUO11kIFC1GeG3Ffa5NOG` | nie |
| CZ-Agents-MCP | `W3W1jZxQ6p328uJpqqvQW` | `git` |
| CRZ-MCP | `zjMf9UUmNVNCQ8SoSu_Px` | nie |
| MCP-EURLEX | `BuUldGCDqtmqnb_c8ZRaq` | nie |
| judikaty-mcp | `HjFcNsx4hr4oe3N1XhtVd` | nie |
| ORSR-MC | `C2QhfOGiSkmsFcQIo2rMn` | nie |
| Slov-lex-MCP | `qveWpPKGKAUPBzfrXPZHG` | `github` |

Dokploy CLI 0.3.0 pri `compose one` vrátilo HTTP 400. Preto presný URL repozitára a deployment commit nie sú označené ako overené. Názov projektu a podobnosť konfigurácie sú iba indície.

## Zistenia a blokátory

### Slov-Lex

- README, package name `slov-lex_mcp` a popis tools potvrdzujú, že obsah repozitára patrí Slov-Lex.
- GitHub description nesprávne uvádza ORSR a musí sa opraviť pred forkom.
- Tokenové vzory v `.env.example`, README a deployment návode sú placeholdery, nie potvrdené secrets.

### ORSR

- Repo sleduje 4 437 súborov pod `node_modules/` a nemá tento priečinok ignorovaný.
- Secret pattern v `node_modules/jose` patrí knižničnému zdrojovému kódu, nie potvrdenému credentialu.
- Odstránenie sledovaného `node_modules/` je samostatná upratovacia zmena. Agentové pravidlá sa nesmú spojiť s veľkým mechanickým diffom bez osobitnej kontroly.

### Agentové pravidlá

- Spoločné minimálne jadro je v [`docs/templates/mcp-repository-AGENTS.md`](../docs/templates/mcp-repository-AGENTS.md).
- Šablóna sa nesmie kopírovať bez doplnenia overeného účelu, zdroja dát a konkrétnych príkazov daného repozitára.
- `OV-MCP`, `RU-MCP` a `UVO-MCP` majú dvojice `AGENTS.md` a `CLAUDE.md` s identickým obsahom.
- Pravidlá v `OV-MCP` a `RU-MCP` neobsahujú presné repozitárové testy a bezpečný deploy boundary.
- Zvyšných 12 upstreamov nemá root dvojicu agentových pravidiel.

## Povinné topics organizačných kópií

Každý cieľ dostane `mcp-server`, `majo-mcp`, `lawoss`, `legaltech` a jednu jurisdikciu: `slovakia`, `czechia` alebo `eu-law`.

## Stav implementačnej brány

Organizačná kópia konkrétneho repozitára sa vytvorí až po splnení týchto bodov:

- [ ] správny osobný upstream,
- [ ] primerane overená Dokploy väzba alebo výslovne zdokumentovaný blokátor,
- [ ] bez nevyriešeného secret nálezu,
- [ ] identické `AGENTS.md` a `CLAUDE.md`,
- [ ] úspešné offline minimum alebo zdokumentované baseline zlyhanie,
- [ ] správny cieľový názov, popis, visibility a topics.
