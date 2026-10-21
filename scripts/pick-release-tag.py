#!/usr/bin/env python3
import json
import re
import sys

SEMVER = re.compile(r'^v?([0-9]+)\.([0-9]+)\.([0-9]+)$')


def main() -> int:
    try:
        releases = json.load(sys.stdin)
    except Exception:
        return 1
    if not isinstance(releases, list):
        return 1
    best = None
    for release in releases:
        if not isinstance(release, dict):
            continue
        if release.get("draft") or release.get("prerelease"):
            continue
        tag = str(release.get("tag_name", "")).strip()
        m = SEMVER.match(tag)
        if not m:
            continue
        key = tuple(int(x) for x in m.groups())
        if best is None or key > best[0]:
            best = (key, tag)
    if best is None:
        return 1
    print(best[1])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
