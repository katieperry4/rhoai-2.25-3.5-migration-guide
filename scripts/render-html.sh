#!/usr/bin/env bash
# Render the concatenated migration guide to a standalone HTML page for
# GitHub Pages. Input is the built Markdown in output/, output is site/index.html.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

SRC="${1:-$ROOT_DIR/output/Migrate from OpenShift AI 2.25 to 3.5.md}"
SITE_DIR="${2:-$ROOT_DIR/site}"

if ! command -v pandoc &>/dev/null; then
    echo "ERROR: pandoc not found. Install it: https://pandoc.org/installing.html" >&2
    exit 1
fi

if [[ ! -f "$SRC" ]]; then
    echo "ERROR: source document not found: $SRC" >&2
    echo "       Run 'make build' first." >&2
    exit 1
fi

mkdir -p "$SITE_DIR"

commit="$(git -C "$ROOT_DIR" rev-parse --short HEAD 2>/dev/null || echo unknown)"
buildstamp="$(date -u '+%Y-%m-%d %H:%M UTC')"

# The source headings carry explicit {#id} attributes matching the document's
# own hand-authored table of contents, so we need a reader that honours
# header_attributes. pandoc's `markdown` reader does; `gfm` does not (and its
# `+attributes` variant mangles the empty headings). smart quotes, TeX math and
# raw TeX are all disabled -- this document is full of shell snippets and
# YAML, and none of those rewrites are ever wanted here.
pandoc \
    --from=markdown-smart-tex_math_dollars-raw_tex \
    --to=html5 \
    --standalone \
    --template="$SCRIPT_DIR/pandoc/template.html" \
    --lua-filter="$SCRIPT_DIR/pandoc/unlisted-empty-headings.lua" \
    --toc --toc-depth=3 \
    --wrap=preserve \
    --metadata title="Migrate from OpenShift AI 2.25 to 3.5 (DRAFT)" \
    --metadata sourcefile="$(basename "$SRC")" \
    --metadata buildstamp="$buildstamp" \
    --metadata commit="$commit" \
    -o "$SITE_DIR/index.html" \
    "$SRC"

# Pages serves this as a plain static directory; .nojekyll keeps GitHub from
# running the files through Jekyll.
touch "$SITE_DIR/.nojekyll"

# Ship the Markdown alongside the page so it can be downloaded directly.
cp "$SRC" "$SITE_DIR/"

echo "Rendered: $SITE_DIR/index.html ($(wc -c < "$SITE_DIR/index.html" | tr -d ' ') bytes)"
