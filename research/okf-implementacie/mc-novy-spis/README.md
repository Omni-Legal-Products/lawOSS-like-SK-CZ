# novy-spis

Skill pre zakladanie nových OKF entít (klient, spis, projekt) podľa štandardizovanej stratégie priečinkov. Automaticky vytvára adresárovú štruktúru OKF v0.1, vypĺňa frontmatter šablón a overuje konformitu — bez zásahu do existujúcich priečinkov.

## Príklady použitia

**Profil A — nový klient + spis (právne veci):**
```bash
scripts/new-klient.sh "ACME s.r.o." --ico 12345678 --root ~/CHZ/Work
scripts/new-spis.sh "Obchodné" "2026-06 ACME - Zmluva o dielo - poradenstvo" \
  --klient-dir ~/CHZ/Work/"ACME s.r.o." \
  --protistrana "Dodávateľ XY" --protistrana-ico 87654321
scripts/okf-validate.sh ~/CHZ/Work/"ACME s.r.o."
scripts/sync_agents_claude.sh ~/CHZ/Work/"ACME s.r.o."
```

**Profil B — nový projekt (interný / nezávislý):**
```bash
scripts/new-projekt.sh "OKF priečinkový systém" --root ~/PROJECTS
scripts/okf-validate.sh ~/PROJECTS/okf-priecinkovy-system
```

## Referenčná špecifikácia
Plná stratégia a konvencie: `~/PROJECTS/SKILLS/project-client-folder-structure/docs/specs/2026-06-15-okf-folder-strategy-design.md`
