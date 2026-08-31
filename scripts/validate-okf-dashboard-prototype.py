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


def validate_smoke(html_path: Path) -> None:
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
            page = browser.new_page()
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
        validate_smoke(html_path)
    print(f"OK: {args.mode} validation passed for {args.html}")


if __name__ == "__main__":
    main()
