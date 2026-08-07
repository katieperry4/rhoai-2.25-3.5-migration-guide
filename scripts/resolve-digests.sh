#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONF="$ROOT_DIR/images.conf"
PLACEHOLDERS="$ROOT_DIR/image-placeholders.conf"
OUT="$ROOT_DIR/images.env"
TIMEOUT="${SKOPEO_TIMEOUT:-30}"

if ! command -v skopeo &>/dev/null; then
    echo "ERROR: skopeo not found. Install it: https://github.com/containers/skopeo/blob/main/install.md" >&2
    exit 1
fi

if [[ ! -f "$CONF" ]]; then
    echo "ERROR: $CONF not found" >&2
    exit 1
fi

old_env=""
if [[ -f "$OUT" ]]; then
    old_env=$(cat "$OUT")
fi

: > "$OUT"
errors=0
fallbacks=0

while IFS= read -r line; do
    [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue

    key=$(echo "$line" | awk '{print $1}')
    image_tag=$(echo "$line" | awk '{print $2}')
    image_name="${image_tag%%:*}"

    echo "Resolving $key ($image_tag)..." >&2

    raw=$(timeout "${TIMEOUT}" skopeo inspect --override-arch amd64 --override-os linux \
        "docker://$image_tag" 2>/dev/null || true)

    if [[ -n "$raw" ]]; then
        digest=$(echo "$raw" | python3 -c "import sys,json; print(json.load(sys.stdin)['Digest'])" 2>/dev/null || true)
    else
        digest=""
    fi

    if [[ -n "$digest" ]]; then
        echo "$key=$image_name@$digest" >> "$OUT"
        echo "  $image_name@$digest" >&2
    else
        existing=$(echo "$old_env" | grep "^$key=" | head -1 || true)
        if [[ -n "$existing" ]]; then
            echo "$existing" >> "$OUT"
            echo "  TIMEOUT/FAIL: using previous digest: ${existing#*=}" >&2
            fallbacks=$((fallbacks + 1))
        else
            has_placeholder=$(grep -q "^$key " "$PLACEHOLDERS" 2>/dev/null && echo "yes" || echo "no")
            if [[ "$has_placeholder" == "yes" ]]; then
                echo "  ERROR: failed to resolve $image_tag (no previous digest, placeholder in use)" >&2
                errors=$((errors + 1))
            else
                echo "  WARNING: failed to resolve $image_tag (no placeholder in use, skipping)" >&2
            fi
        fi
    fi
done < "$CONF"

if [[ $errors -gt 0 ]]; then
    echo "ERROR: $errors image(s) failed to resolve with no fallback" >&2
    exit 1
fi

if [[ $fallbacks -gt 0 ]]; then
    echo "WARNING: $fallbacks image(s) used previous digest (timeout or resolve failure)" >&2
fi

echo "Wrote $OUT" >&2
