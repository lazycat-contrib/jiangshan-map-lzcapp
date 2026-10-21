#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
upstream_dir="$(mktemp -d)"
source_dir="${UPSTREAM_SOURCE_DIR:-}"

cleanup() {
  rm -rf "${upstream_dir}"
}
trap cleanup EXIT

# The upstream GitHub Release tag is the version authority for this app, so
# build the newest stable vMAJOR.MINOR.PATCH release instead of main.
if [[ -z "${source_dir}" ]]; then
  release_tag="$(curl --fail --silent --show-error --location --retry 3 --retry-all-errors     -H "Accept: application/vnd.github+json"     "https://api.github.com/repos/DeanChensj/jiangshan-map/releases?per_page=20"     | python3 "${project_root}/scripts/pick-release-tag.py")"
  test -n "${release_tag}"
  printf "Building upstream release %s\n" "${release_tag}"

  source_dir="${upstream_dir}/source"
  mkdir -p "${source_dir}"
  curl --fail --location --retry 3 --retry-all-errors \
    "https://codeload.github.com/DeanChensj/jiangshan-map/tar.gz/refs/tags/${release_tag}" \
    | tar -xz --strip-components=1 -C "${source_dir}"
else
  source_dir="$(cd "${source_dir}" && pwd)"
  printf "Building local source tree %s\n" "${source_dir}"
fi

# Upstream CI runs the same validation suite; not fatal here since it is a
# content check, but running it keeps broken data out of the package.
node "${source_dir}/scripts/validate_atlas.js" || true

rm -rf "${project_root}/dist"
mkdir -p "${project_root}/dist"
for entry in index.html assets js css topics llms.txt sitemap.xml robots.txt; do
  if [[ -e "${source_dir}/${entry}" ]]; then
    cp -a "${source_dir}/${entry}" "${project_root}/dist/"
  fi
done
