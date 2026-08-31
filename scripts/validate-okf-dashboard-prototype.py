#!/opt/homebrew/opt/python@3.14/bin/python3.14
from __future__ import annotations

import argparse
import re
from pathlib import Path

DIRECTIONS = ("registry", "timeline", "constellation", "ledger", "brain", "tower")
SCENARIOS = ("current", "empty", "partial", "stale", "parse-error", "future-version", "offline")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def validate_static(html_path: Path) -> None:
    html = html_path.read_text(encoding="utf-8")
    require("Fiktívne dáta · pracovný návrh" in html, "missing demo marker")
    require("ALFA STAV s.r.o." in html, "missing reference matter")
    require("14. 9. 2026" in html, "missing candidate deadline")
    require("base_revision" in html and "base_hash" in html, "missing concurrency trace")
    require("—" not in html, "em dash is forbidden")
    require(not re.search(r'(?:src|href)=["\']https?://', html), "external request found")
    for fragment in (
        "const DATA = Object.freeze(",
        "const appState =",
        "function setDirection(",
        "function setScenario(",
        'data-testid="direction-gallery"',
        'data-testid="presentation-toggle"',
        'data-testid="shortcut-help"',
        "Případ · lhůta · důkaz · řízení",
    ):
        require(fragment in html, f"missing shared primitive: {fragment}")
    for index, direction in enumerate(DIRECTIONS, start=1):
        require(f'data-direction="{direction}"' in html, f"missing direction {direction}")
        require(f'data-testid="direction-{index}"' in html, f"missing direction test id {index}")
    for scenario in SCENARIOS:
        require(f'data-scenario="{scenario}"' in html, f"missing scenario {scenario}")
    for fragment in (
        'data-testid="source-inspector"',
        'data-testid="human-gate"',
        'role="dialog"',
        'aria-modal="true"',
        "function openSourceInspector(",
        "function closeSourceInspector(",
        "function openHumanGate(",
        "function closeHumanGate(",
        "function isTypingTarget(",
        "function closeTopLayerOrPresentation(",
        "Demonštračný stav · nič sa nezapísalo",
        "Prepočítať návrh",
        "base_revision: 18",
        "base_hash: 81aa39f2",
    ):
        require(fragment in html, f"missing task 6 primitive: {fragment}")
    for test_id in (
        "registry-decision-queue",
        "deadline-strip",
        "timeline-diagram",
        "event-delivery",
        "event-deadline-candidate",
        "text-fallback",
    ):
        require(f'data-testid="{test_id}"' in html, f"missing direction primitive: {test_id}")
    for fragment in (
        "function setTimelineEvent(id)",
        "Podanie",
        "Dokazovanie",
        "Rozhodnutie",
        "§ 362 ods. 1 CSP · demonštračný údaj",
        "Žiadna potvrdená budúca lehota",
        "návrh vytvorený 31. 8. 2026",
        "navrhovaný termín 14. 9. 2026",
        'data-source-kind="event"',
        'data-source-id="event-deadline-candidate"',
    ):
        require(fragment in html, f"missing direction invariant: {fragment}")
    for test_id in (
        "evidence-graph",
        "graph-node-T-2026-029",
        "graph-node-F-2026-020",
        "graph-list-fallback",
        "audit-ledger",
        "ledger-item-OKF_PARSE_002",
        "ledger-item-OKF_STALE_001",
        "ledger-diff",
        "ledger-provenance",
        "ledger-history",
    ):
        require(f'data-testid="{test_id}"' in html, f"missing task 4 primitive: {test_id}")
    for fragment in (
        "function spotlightNode(id)",
        "function setLedgerItem(id)",
        "recordId",
        'data-node-type="document"',
        'data-node-type="evidence"',
        'data-node-type="truth"',
        'data-node-type="decision"',
        'data-node-type="finding"',
        'data-node-type="subject"',
        'data-relation',
        'data-source-kind="record"',
    ):
        require(fragment in html, f"missing task 4 invariant: {fragment}")
    for test_id in (
        "brain-layers",
        "brain-matter-brief",
        "brain-layer-detail",
        "brain-pending-findings",
        "risk-matrix",
        "risk-breadcrumb",
    ):
        require(f'data-testid="{test_id}"' in html, f"missing task 5 primitive: {test_id}")
    for fragment in (
        'data-brain-layer="L1"',
        'data-brain-layer="L2"',
        'data-brain-layer="L3"',
        "function setBrainLayer(layer)",
        "L2-to-L3 leak kontrola",
        'data-risk-lens="urgency"',
        'data-risk-lens="evidence"',
        'data-risk-lens="data-health"',
        'data-risk-lens="workload"',
        "function setRiskLens(id)",
        "Lehota",
        "Chýbajúci zdroj",
        "Stale",
        "Human gate",
        "Provider",
    ):
        require(fragment in html, f"missing task 5 invariant: {fragment}")
    require("drag-and-drop" not in html.lower(), "brain must not offer drag-and-drop")


def validate_smoke(html_path: Path, artifacts: Path | None = None) -> None:
    try:
        from playwright.sync_api import sync_playwright
    except ImportError as exc:
        raise AssertionError(
            "Playwright is required for smoke and full validation"
        ) from exc

    page_errors: list[str] = []
    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(headless=True)
        try:
            page = browser.new_page(viewport={"width": 1440, "height": 1024})
            page.on("pageerror", lambda error: page_errors.append(str(error)))
            page.goto(html_path.as_uri(), wait_until="load")

            initial = page.evaluate(
                """() => ({
                    galleryOpen: !document.querySelector(
                        '[data-testid="direction-gallery"]'
                    ).hidden,
                    activeRoots: [...document.querySelectorAll(
                        '.direction-root[data-active="true"]'
                    )].map((root) => root.dataset.direction),
                    registryControls: document.querySelectorAll(
                        '[data-direction-target="registry"]'
                    ).length,
                    registryCurrent: document.querySelectorAll(
                        '[data-direction-target="registry"][aria-current="page"]'
                    ).length,
                    dataSnapshot: JSON.stringify(DATA)
                })"""
            )
            require(initial["galleryOpen"], "gallery is not open on initial load")
            require(
                initial["activeRoots"] == ["registry"],
                "initial load must have exactly one active registry root",
            )
            require(initial["registryControls"] > 0, "registry controls are missing")
            require(
                initial["registryCurrent"] == initial["registryControls"],
                "initial registry controls do not match aria-current",
            )

            page.evaluate("setDirection('registry')")
            registry = page.evaluate(
                """() => ({
                    activeRoots: [...document.querySelectorAll(
                        '.direction-root[data-active="true"]'
                    )].map((root) => root.dataset.direction),
                    decisionRows: document.querySelectorAll(
                        '[data-testid="registry-decision-queue"] details'
                    ).length,
                    candidateCopy: document.querySelector(
                        '[data-testid="deadline-strip"]'
                    ).textContent,
                    fallbackCopy: document.querySelector(
                        '[data-testid="text-fallback"]'
                    ).textContent
                })"""
            )
            require(
                registry["activeRoots"] == ["registry"],
                "registry interaction must leave exactly one active root",
            )
            require(registry["decisionRows"] == 3, "registry queue must have 3 rows")
            require(
                "Žiadna potvrdená budúca lehota" in registry["candidateCopy"],
                "registry must show the confirmed deadline empty state",
            )
            require(
                "návrh, čaká na potvrdenie" in registry["fallbackCopy"],
                "registry text fallback is missing proposal semantics",
            )

            page.evaluate("setDirection('timeline')")
            require(
                page.locator("[data-timeline-event]").count() == 6,
                "timeline must render all six fixture events",
            )
            page.locator('[data-testid="event-delivery"]').click()
            delivery = page.evaluate(
                """() => ({
                    selected: [...document.querySelectorAll(
                        '[data-timeline-event][aria-selected="true"]'
                    )].map((item) => item.dataset.timelineEvent),
                    detail: document.querySelector(
                        '[data-testid="timeline-detail"]'
                    ).textContent,
                    state: appState.selectedTimelineEvent,
                    source: (() => {
                        const source = document.querySelector(
                            '[data-timeline-detail-source]'
                        );
                        return {
                            kind: source.dataset.sourceKind,
                            id: source.dataset.sourceId,
                            path: source.textContent
                        };
                    })()
                })"""
            )
            require(
                delivery["selected"] == ["event-delivery"],
                "delivery click must select exactly the delivery event",
            )
            require(
                delivery["state"] == "event-delivery",
                "delivery click did not update timeline state",
            )
            require(
                "evidence/edelivery/receipt.json:12" in delivery["detail"],
                "delivery detail is missing source provenance",
            )
            require(
                delivery["source"]
                == {
                    "kind": "event",
                    "id": "event-delivery",
                    "path": "evidence/edelivery/receipt.json:12",
                },
                "delivery detail source must use the typed event contract",
            )

            page.locator('[data-testid="event-deadline-candidate"]').click()
            deadline = page.evaluate(
                """() => {
                    const source = document.querySelector(
                        '[data-timeline-detail-source]'
                    );
                    return {
                        card: document.querySelector(
                            '[data-testid="event-deadline-candidate"]'
                        ).textContent,
                        detail: document.querySelector(
                            '[data-testid="timeline-detail"]'
                        ).textContent,
                        fallback: document.querySelector(
                            '.timeline-fallback'
                        ).textContent,
                        source: {
                            kind: source.dataset.sourceKind,
                            id: source.dataset.sourceId,
                            path: source.textContent
                        }
                    };
                }"""
            )
            for expected in (
                "§ 362 ods. 1 CSP · demonštračný údaj",
                "pracovný snapshot označený 2026-08-31",
                "deň doručenia sa nezapočíta",
                "treba potvrdiť trigger, aplikovaný právny režim a pravidlo posunu",
            ):
                require(expected in deadline["detail"], f"timeline detail missing: {expected}")
            for surface, copy in (
                ("candidate card", deadline["card"]),
                ("candidate detail", deadline["detail"]),
                ("timeline fallback", deadline["fallback"]),
            ):
                for expected in (
                    "návrh vytvorený 31. 8. 2026",
                    "navrhovaný termín 14. 9. 2026",
                    "návrh, čaká na potvrdenie",
                ):
                    require(
                        expected in copy,
                        f"{surface} is missing candidate deadline semantics: {expected}",
                    )
            require(
                deadline["source"]
                == {
                    "kind": "event",
                    "id": "event-deadline-candidate",
                    "path": "findings/deadlines/F-2026-018.md:24",
                },
                "candidate deadline detail source must use the typed event contract",
            )

            data_before_task_4 = page.evaluate("JSON.stringify(DATA)")
            page.evaluate("setDirection('constellation')")
            page.locator('[data-testid="graph-node-T-2026-029"]').click()
            graph = page.evaluate(
                """() => ({
                    selected: [...document.querySelectorAll(
                        '[data-graph-node][aria-pressed="true"]'
                    )].map((item) => item.dataset.graphNode),
                    state: appState.spotlightNode,
                    activeEdges: document.querySelectorAll(
                        '[data-graph-edge][data-path-active="true"]'
                    ).length,
                    dimmedEdges: document.querySelectorAll(
                        '[data-graph-edge][data-path-active="false"]'
                    ).length,
                    detail: document.querySelector(
                        '[data-testid="graph-inspector"]'
                    ).textContent,
                    source: (() => {
                        const source = document.querySelector(
                            '[data-graph-detail-source]'
                        );
                        return {
                            kind: source.dataset.sourceKind,
                            id: source.dataset.sourceId
                        };
                    })(),
                    fallbackEdges: document.querySelectorAll(
                        '[data-testid="graph-list-fallback"] tbody tr'
                    ).length,
                    svgTuples: [...document.querySelectorAll(
                        '[data-graph-edge]'
                    )].map((edge) => [
                        edge.dataset.from,
                        edge.dataset.relation,
                        edge.dataset.to,
                        edge.dataset.status
                    ]),
                    fallbackTuples: [...document.querySelectorAll(
                        '[data-testid="graph-list-fallback"] tbody tr'
                    )].map((row) => [
                        row.dataset.from,
                        row.dataset.relation,
                        row.dataset.to,
                        row.dataset.status
                    ]),
                    graphNodeIds: [...document.querySelectorAll(
                        '[data-graph-node]'
                    )].map((node) => node.dataset.graphNode),
                    recordIds: DATA.records.map((record) => record.id)
                })"""
            )
            require(
                graph["selected"] == ["T-2026-029"],
                "graph spotlight must select exactly one node",
            )
            require(
                graph["state"] == "T-2026-029",
                "graph spotlight did not update state",
            )
            require(
                graph["activeEdges"] > 0 and graph["dimmedEdges"] > 0,
                "graph spotlight must distinguish path and unrelated edges",
            )
            require(
                "memory/matters/T-2026-029.md:18" in graph["detail"],
                "graph inspector is missing truth provenance",
            )
            require(
                graph["source"] == {"kind": "record", "id": "T-2026-029"},
                "graph source must use the typed record contract",
            )
            require(
                graph["fallbackEdges"]
                == page.locator("[data-graph-edge]").count(),
                "graph fallback and SVG must expose the same edges",
            )
            require(
                sorted(graph["svgTuples"]) == sorted(graph["fallbackTuples"]),
                "graph fallback and SVG must expose identical canonical edge tuples",
            )
            require(
                [
                    "F-2026-020",
                    "vyžaduje posúdenie",
                    "D-2026-011",
                    "partial",
                ] in graph["svgTuples"],
                "F-2026-020 to D-2026-011 must be partial",
            )
            graph_source_map = {
                "DOC-2026-024": "T-2026-029",
                "EVID-2026-028": "T-2026-029",
                "SUBJ-2026-002": "F-2026-020",
                "DOC-2026-031": "F-2026-020",
                "T-2026-029": "T-2026-029",
                "D-2026-011": "D-2026-011",
                "F-2026-021": "F-2026-021",
                "F-2026-020": "F-2026-020",
            }
            require(
                set(graph["graphNodeIds"]) == set(graph_source_map),
                "graph node IDs do not match the approved presentation fixture",
            )
            require(
                set(graph_source_map.values()).issubset(set(graph["recordIds"])),
                "graph source map points outside DATA.records",
            )
            graph_sources = page.evaluate(
                """(nodeIds) => nodeIds.map((id) => {
                    spotlightNode(id);
                    const source = document.querySelector(
                        '[data-graph-detail-source]'
                    );
                    return {
                        graphNode: id,
                        sourceKind: source.dataset.sourceKind,
                        sourceId: source.dataset.sourceId,
                        selected: [...document.querySelectorAll(
                            '[data-graph-node][aria-pressed="true"]'
                        )].map((node) => node.dataset.graphNode)
                    };
                })""",
                graph["graphNodeIds"],
            )
            for source in graph_sources:
                require(
                    source["sourceKind"] == "record",
                    f"graph trigger for {source['graphNode']} must use record source kind",
                )
                require(
                    source["sourceId"] == graph_source_map[source["graphNode"]],
                    f"graph trigger for {source['graphNode']} has wrong canonical source ID",
                )
                require(
                    source["sourceId"] in graph["recordIds"],
                    f"graph trigger source ID is missing from DATA.records: {source['sourceId']}",
                )
                require(
                    source["selected"] == [source["graphNode"]],
                    f"graph node selection changed presentation ID for {source['graphNode']}",
                )

            page.evaluate("setDirection('ledger')")
            page.locator('[data-testid="ledger-item-OKF_PARSE_002"]').press("Enter")
            ledger = page.evaluate(
                """() => ({
                    selected: [...document.querySelectorAll(
                        '[data-ledger-item][aria-selected="true"]'
                    )].map((item) => item.dataset.ledgerItem),
                    state: appState.selectedLedgerItem,
                    detail: document.querySelector(
                        '[data-testid="ledger-inspector"]'
                    ).textContent,
                    source: (() => {
                        const source = document.querySelector(
                            '[data-ledger-detail-source]'
                        );
                        return {
                            kind: source.dataset.sourceKind,
                            id: source.dataset.sourceId
                        };
                    })(),
                    dataSnapshot: JSON.stringify(DATA)
                })"""
            )
            require(
                ledger["selected"] == ["OKF_PARSE_002"],
                "ledger must have exactly one aria-selected row",
            )
            require(
                ledger["state"] == "OKF_PARSE_002",
                "ledger selection did not update state",
            )
            for expected in (
                "Diff",
                "Provenance",
                "Append-only History",
                "Odporúčaný ďalší krok",
                "memory/questions/Q-2026-009.md:7",
            ):
                require(expected in ledger["detail"], f"ledger detail missing: {expected}")
            require(
                ledger["source"] == {"kind": "record", "id": "OKF_PARSE_002"},
                "ledger source must use the typed record contract",
            )
            require(
                ledger["dataSnapshot"] == data_before_task_4,
                "DATA changed during graph or ledger interaction",
            )

            page.evaluate("setDirection('brain')")
            brain_initial = page.evaluate(
                """() => ({
                    pressed: [...document.querySelectorAll(
                        '[data-brain-layer][aria-pressed="true"]'
                    )].map((button) => button.dataset.brainLayer),
                    state: appState.brainLayer,
                    brief: document.querySelector(
                        '[data-testid="brain-matter-brief"]'
                    ).textContent,
                    detail: document.querySelector(
                        '[data-testid="brain-layer-detail"]'
                    ).textContent,
                    pending: document.querySelectorAll(
                        '[data-testid="brain-pending-findings"] [data-pending-finding]'
                    ).length
                })"""
            )
            require(brain_initial["pressed"] == ["L2"], "brain must start on L2")
            require(brain_initial["state"] == "L2", "brain state must start on L2")
            require(
                "ALFA STAV s.r.o." in brain_initial["brief"],
                "brain matter brief must remain visible",
            )
            for record_id in ("T-2026-029", "D-2026-011", "Q-2026-004", "TASK-2026-044"):
                require(record_id in brain_initial["detail"], f"brain L2 missing {record_id}")
            require(brain_initial["pending"] == 2, "brain must show two pending findings")

            page.evaluate("setBrainLayer('L1')")
            brain_l1 = page.evaluate(
                """() => ({
                    pressed: [...document.querySelectorAll(
                        '[data-brain-layer][aria-pressed="true"]'
                    )].map((button) => button.dataset.brainLayer),
                    detail: document.querySelector(
                        '[data-testid="brain-layer-detail"]'
                    ).textContent,
                    trigger: (() => {
                        const button = document.querySelector(
                            '[data-brain-gate-trigger]'
                        );
                        return {
                            recordId: button.dataset.recordId,
                            gateId: button.dataset.gateId,
                            text: button.textContent
                        };
                    })()
                })"""
            )
            require(brain_l1["pressed"] == ["L1"], "L1 must be aria-pressed")
            require("human gate" in brain_l1["detail"], "L1 preview must require human gate")
            require(
                brain_l1["trigger"]["recordId"] == "F-2026-021",
                "L1 gate trigger must use a DATA.records ID",
            )
            require(brain_l1["trigger"]["gateId"], "L1 gate trigger is missing gate ID")
            page.evaluate(
                """() => {
                    window.__task5GateRequest = null;
                    document.addEventListener(
                        'okf:gate-request',
                        (event) => { window.__task5GateRequest = event.detail; },
                        { once: true }
                    );
                }"""
            )
            page.locator("[data-brain-gate-trigger]").click()
            require(
                page.evaluate("window.__task5GateRequest")
                == {
                    "gateId": "promotion-L1-F-2026-021",
                    "recordId": "F-2026-021",
                },
                "L1 trigger must emit a compatible gate request without writing",
            )
            page.get_by_test_id("human-gate").get_by_role(
                "button", name="Zavrieť human gate"
            ).click()

            page.evaluate("setBrainLayer('L3')")
            brain_l3 = page.locator('[data-testid="brain-layer-detail"]').inner_text()
            require("právna kontrola" in brain_l3, "L3 must require legal review")
            require("L2-to-L3 leak kontrola" in brain_l3, "L3 leak copy is missing")

            page.evaluate("setDirection('tower')")
            tower_initial = page.evaluate(
                """() => ({
                    rows: document.querySelectorAll(
                        '[data-testid="risk-matrix"] tbody tr'
                    ).length,
                    pressed: [...document.querySelectorAll(
                        '[data-risk-lens][aria-pressed="true"]'
                    )].map((button) => button.dataset.riskLens),
                    state: appState.riskLens,
                    headers: [...document.querySelectorAll(
                        '[data-testid="risk-matrix"] thead th'
                    )].map((cell) => cell.textContent.trim()),
                    portfolio: DATA.portfolio.map((item) => item.client),
                    rendered: [...document.querySelectorAll(
                        '[data-testid="risk-matrix"] tbody tr'
                    )].map((row) => row.dataset.portfolioClient)
                })"""
            )
            require(tower_initial["rows"] == 5, "tower must render five portfolio rows")
            require(tower_initial["pressed"] == ["urgency"], "tower must start on urgency")
            require(tower_initial["state"] == "urgency", "tower state must start on urgency")
            require(
                tower_initial["headers"][-5:]
                == ["Lehota", "Chýbajúci zdroj", "Stale", "Human gate", "Provider"],
                "tower transparent columns are missing or reordered",
            )
            require(
                tower_initial["rendered"] == tower_initial["portfolio"],
                "tower rows must render DATA.portfolio exactly",
            )
            for lens in ("urgency", "evidence", "data-health", "workload"):
                page.evaluate("(value) => setRiskLens(value)", lens)
                require(
                    page.locator(f'[data-risk-lens="{lens}"]').get_attribute("aria-pressed")
                    == "true",
                    f"{lens} lens must update aria-pressed",
                )
            task_5_sources = page.evaluate(
                """() => {
                    const recordIds = new Set(DATA.records.map((record) => record.id));
                    return [...document.querySelectorAll(
                        '[data-direction="brain"] [data-source-trigger][data-source-kind="record"], '
                        + '[data-direction="tower"] [data-source-trigger][data-source-kind="record"]'
                    )].map((trigger) => ({
                        id: trigger.dataset.sourceId,
                        valid: recordIds.has(trigger.dataset.sourceId)
                    }));
                }"""
            )
            require(task_5_sources, "task 5 must expose typed record source triggers")
            require(
                all(source["valid"] for source in task_5_sources),
                "task 5 source trigger points outside DATA.records",
            )
            nav_entries_before = page.evaluate("performance.getEntriesByType('navigation').length")
            page.locator('[data-portfolio-drilldown="ALFA STAV s.r.o."]').click()
            page.wait_for_function("window.location.hash === '#registry'")
            drilldown = page.evaluate(
                """() => ({
                    hash: window.location.hash,
                    direction: appState.direction,
                    navigationEntries: performance.getEntriesByType('navigation').length,
                    breadcrumb: document.querySelector(
                        '[data-testid="risk-breadcrumb"]'
                    ).textContent,
                    dataSnapshot: JSON.stringify(DATA)
                })"""
            )
            require(drilldown["hash"] == "#registry", "ALFA drill-down must route to #registry")
            require(drilldown["direction"] == "registry", "ALFA drill-down must open registry")
            require(
                drilldown["navigationEntries"] == nav_entries_before,
                "ALFA drill-down must not reload the page",
            )
            require("Prax" in drilldown["breadcrumb"], "drill-down must preserve breadcrumb to prax")
            require(drilldown["dataSnapshot"] == initial["dataSnapshot"], "DATA changed in task 5")

            page.keyboard.press("2")
            require(appState := page.evaluate("appState.direction"), "keyboard state is unavailable")
            require(appState == "timeline", "2 must activate the timeline direction")
            page.keyboard.press("ArrowRight")
            require(page.evaluate("appState.direction") == "constellation", "ArrowRight must advance directions")
            page.keyboard.press("ArrowLeft")
            require(page.evaluate("appState.direction") == "timeline", "ArrowLeft must return directions")
            page.keyboard.press("F")
            require(page.evaluate("appState.presentation") is True, "F must enable presentation mode")
            page.keyboard.press("Escape")
            require(page.evaluate("appState.presentation") is False, "Escape must close presentation mode")
            scenario_select = page.get_by_test_id("scenario-select")
            scenario_select.focus()
            page.keyboard.press("1")
            require(page.evaluate("appState.direction") == "timeline", "typing target must ignore numeric shortcuts")

            source_trigger = page.locator('[data-testid="timeline-detail"] [data-source-trigger]')
            source_trigger.click()
            inspector = page.get_by_test_id("source-inspector")
            require(inspector.is_visible(), "source inspector must open from the timeline trigger")
            inspector_text = inspector.inner_text().lower()
            for expected in (
                "ui hodnota",
                "read model",
                "kanonický záznam",
                "súbor a riadok",
                "evidence",
                "history",
                "findings/deadlines/f-2026-018.md:24",
            ):
                require(expected in inspector_text, f"source inspector missing: {expected}")
            inspector.get_by_role("button", name="Zavrieť zdroj").click()
            require(page.evaluate("document.activeElement === document.querySelector('[data-testid=\"timeline-detail\"] [data-source-trigger]')"), "source inspector must restore trigger focus")

            page.evaluate("setDirection('brain')")
            page.evaluate("setBrainLayer('L1')")
            gate_trigger = page.locator("[data-brain-gate-trigger]")
            gate_trigger.click()
            gate = page.get_by_test_id("human-gate")
            require(gate.is_visible(), "human gate must open from a compatible request")
            gate_text = gate.inner_text().lower()
            for expected in (
                "zdroj",
                "locator",
                "navrhovaný diff",
                "pomenovaná neistota",
                "cieľ zápisu",
                "base_revision: 18",
                "base_hash: 81aa39f2",
                "tento prototyp nič nezapíše",
            ):
                require(expected in gate_text, f"human gate missing: {expected}")
            for action_name in ("Potvrdiť", "Upraviť", "Odmietnuť", "Odložiť"):
                gate.get_by_role("button", name=action_name).click()
                require(
                    "Demonštračný stav · nič sa nezapísalo" in gate.inner_text(),
                    f"{action_name} must only announce demo state",
                )
            page.evaluate("setScenario('stale')")
            require(gate.get_by_role("button", name="Potvrdiť").is_disabled(), "stale gate must disable confirmation")
            require(gate.get_by_role("button", name="Upraviť").is_disabled(), "stale gate must disable editing")
            require(gate.get_by_role("button", name="Prepočítať návrh").is_visible(), "stale gate must offer recomputation")
            require(
                gate.locator('[name="changed-input"]').get_attribute("name")
                == "changed-input",
                "stale gate must name the changed input",
            )
            page.evaluate("setScenario('future-version')")
            require(gate.get_by_role("button", name="Potvrdiť").is_disabled(), "future version must remain read-only")
            require(gate.get_by_role("button", name="Odmietnuť").is_disabled(), "future version must disable write actions")
            gate.get_by_role("button", name="Zavrieť human gate").click()
            require(page.evaluate("document.activeElement === document.querySelector('[data-brain-gate-trigger]')"), "human gate must restore trigger focus")

            for scenario in SCENARIOS:
                page.evaluate("(id) => setScenario(id)", scenario)
                require(page.evaluate("document.body.dataset.scenario") == scenario, f"scenario did not render: {scenario}")
                require(page.locator('.direction-root[data-active="true"]').count() == 1, "scenario must keep one active direction")
            page.evaluate("setScenario('current')")

            for direction in DIRECTIONS:
                page.evaluate("(id) => setDirection(id)", direction)
                direction_source = page.locator(
                    f'[data-direction="{direction}"] [data-source-trigger]'
                ).first
                require(
                    direction_source.count() == 1,
                    f"{direction} must expose a functional source path",
                )
                direction_source.click()
                require(inspector.is_visible(), f"{direction} source path must open inspector")
                inspector.get_by_role("button", name="Zavrieť zdroj").click()

            page.evaluate("setDirection('tower')")
            for lens in ("urgency", "evidence", "data-health", "workload"):
                page.locator(f'[data-risk-lens="{lens}"]').click()
                lens_rows = page.locator('[data-testid="risk-matrix"] tbody tr').evaluate_all(
                    "rows => rows.map((row) => row.dataset.portfolioClient)"
                )
                require(
                    sorted(lens_rows) == sorted(page.evaluate("DATA.portfolio.map((item) => item.client)")),
                    f"{lens} must retain every portfolio client exactly once",
                )
            page.locator('[data-portfolio-drilldown="ALFA STAV s.r.o."]').click()
            page.locator('[data-practice-return] [data-direction-target="tower"]').click()
            practice_reset = page.evaluate(
                """() => ({
                    direction: appState.direction,
                    drilldown: appState.practiceDrilldown,
                    returnHidden: document.querySelector('[data-practice-return]').hidden
                })"""
            )
            require(practice_reset == {"direction": "tower", "drilldown": False, "returnHidden": True}, "return to Tower must clear the stale practice breadcrumb state")

            if artifacts is not None:
                artifacts.mkdir(parents=True, exist_ok=True)
                page.screenshot(path=artifacts / "direction-4-audit-ledger.png")
                page.evaluate("setDirection('constellation')")
                page.evaluate("spotlightNode('T-2026-029')")
                page.screenshot(path=artifacts / "direction-3-evidence-constellation.png")
                page.evaluate("setDirection('brain')")
                page.evaluate("setBrainLayer('L2')")
                page.screenshot(path=artifacts / "direction-5-okf-brain.png")
                page.evaluate("setDirection('tower')")
                page.evaluate("setRiskLens('urgency')")
                page.screenshot(path=artifacts / "direction-6-risk-control-tower.png")

            page.evaluate("setDirection('tower')")
            page.wait_for_function("window.location.hash === '#tower'")
            tower = page.evaluate(
                """() => ({
                    activeRoots: [...document.querySelectorAll(
                        '.direction-root[data-active="true"]'
                    )].map((root) => root.dataset.direction),
                    inactiveSafe: [...document.querySelectorAll(
                        '.direction-root[data-active="false"]'
                    )].every((root) => root.hidden && root.inert),
                    towerControls: document.querySelectorAll(
                        '[data-direction-target="tower"]'
                    ).length,
                    towerCurrent: document.querySelectorAll(
                        '[data-direction-target="tower"][aria-current="page"]'
                    ).length
                })"""
            )
            require(
                tower["activeRoots"] == ["tower"],
                "tower routing must leave exactly one active tower root",
            )
            require(tower["inactiveSafe"], "inactive roots are not hidden and inert")
            require(tower["towerControls"] > 0, "tower controls are missing")
            require(
                tower["towerCurrent"] == tower["towerControls"],
                "tower controls do not match aria-current",
            )

            page.evaluate("window.location.hash = '#invalid'")
            page.wait_for_function(
                "!document.querySelector('[data-testid=\"direction-gallery\"]').hidden"
            )
            final_state = page.evaluate(
                """() => {
                    const isDeepFrozen = (value) => {
                        if (value === null || typeof value !== 'object') return true;
                        return Object.isFrozen(value)
                            && Object.values(value).every(isDeepFrozen);
                    };
                    return {
                        dataSnapshot: JSON.stringify(DATA),
                        dataFrozen: isDeepFrozen(DATA)
                    };
                }"""
            )
            require(not page_errors, f"runtime page error: {'; '.join(page_errors)}")
            require(
                final_state["dataSnapshot"] == initial["dataSnapshot"],
                "DATA changed during routing smoke",
            )
            require(final_state["dataFrozen"], "DATA is not deeply frozen")
        finally:
            browser.close()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--html", type=Path, required=True)
    parser.add_argument("--mode", choices=("static", "smoke", "full"), default="static")
    parser.add_argument("--artifacts", type=Path)
    args = parser.parse_args()
    html_path = args.html.resolve()
    validate_static(html_path)
    if args.mode in ("smoke", "full"):
        artifacts = args.artifacts.resolve() if args.artifacts else None
        validate_smoke(html_path, artifacts)
    print(f"OK: {args.mode} validation passed for {args.html}")


if __name__ == "__main__":
    main()
