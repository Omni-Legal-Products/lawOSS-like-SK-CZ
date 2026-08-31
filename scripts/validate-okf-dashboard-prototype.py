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
            page.evaluate("spotlightNode('T-2026-029')")
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
                "DOC-2026-031": "F-2026-021",
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
            page.evaluate("setLedgerItem('OKF_PARSE_002')")
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

            if artifacts is not None:
                artifacts.mkdir(parents=True, exist_ok=True)
                page.screenshot(path=artifacts / "direction-4-audit-ledger.png")
                page.evaluate("setDirection('constellation')")
                page.evaluate("spotlightNode('T-2026-029')")
                page.screenshot(path=artifacts / "direction-3-evidence-constellation.png")

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
