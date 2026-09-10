# Jednotný shell aplikácie a experimentov

Zadanie MČ z 10. 9. 2026: experimenty nesmú pôsobiť ako druhá aplikácia. Nadväzuje na dizajnový systém, ktorý už označuje pôvodné demo layouty za nevhodný vzor integrácie.

Implementácia vo vetve produktu `fix/unified-experiments-shell`:
- Všetky existujúce experimentálne URL renderuje SessionRoute cez existujúci mainView slot.
- Jeden hlavný sidebar, rovnaká značka, priečinky, ovládanie okna a stavový riadok.
- Experimentálna navigácia je nad obsahom; samostatný ľavý rail a odkaz Späť do aplikácie sa odstránia.
- Workspace refresh zachová experimentálne URL. Návrat z Workflows na ten istý experiment musí tiež vyčistiť aktívny pomocný panel.
- Husté registre sa prispôsobujú šírke obsahového panelu, nie iba šírke okna.
- Nové funkcie sa integrujú cez existujúci shell; nevytvára sa paralelný layout ani backend.

Overenie: TypeScript, produkčný build, 12 existujúcich testov experimentov, prehliadačová cesta Experimenty → Lehoty → Workflows → rovnaké Lehoty. Následne prešiel aj smoke test nainštalovaného Electron buildu: existujúci priečinok a relácia → Experimenty so zachovaným sidebarom. Funkčnosť právnych operácií nad spisom tým nie je overená. [Zápis, preview a otvorené body](../../planning/2026-09-10-zapis-logo-sidebar-a-sync.md).

Šesť alternatív identity: [vektorové návrhy](../../assets/brand/loga-2026-09-10/README.md). MČ následne vybral B; tento variant je integrovaný do publikovaného preview.
