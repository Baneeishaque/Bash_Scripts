#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# install_vscode_recommendations.bash
#
# Reads .vscode/extensions.json → recommendations[]
# For each ext:
#   • Adds it to settingsSync.ignoredExtensions
#   • If already installed → skips (then optionally enables)
#   • Else tries, in order:
#       1) Marketplace CLI
#       2) Open VSX VSIX
#       3) Official Marketplace VSIX (compatible version via assetbyname URL)
#   • All VSIX installs funnel through install_vsix()
#   • Uses pure Bash + sort -V for semver checks (no Node)
# -----------------------------------------------------------------------------

fail() {
  echo "❌ $1" >&2
  exit 1
}

# prerequisites
for cmd in jq code curl uname sort grep tr sed mktemp date; do
  command -v "$cmd" >/dev/null \
    || fail "Required command not found in PATH: $cmd"
done

# detect --enable-extension support
if code --help | grep -q -- '--enable-extension'; then
  SUPPORT_ENABLE=true
else
  SUPPORT_ENABLE=false
  echo "⚠️  --enable-extension not supported; skipping enable steps."
fi

# load recommendations
EXT_FILE=".vscode/extensions.json"
[[ -f $EXT_FILE ]]   || fail "No $EXT_FILE"
jq empty "$EXT_FILE" 2>/dev/null \
  || fail "$EXT_FILE is invalid JSON"
mapfile -t RECS < <(jq -r '.recommendations // [] | .[]' "$EXT_FILE")
(( ${#RECS[@]} )) || { echo "ℹ️ No recommendations to process."; exit 0; }

# installed list (lowercased)
mapfile -t INSTALLED < <(code --list-extensions | tr '[:upper:]' '[:lower:]')

# locate & backup settings.json
case "$(uname -s)" in
  Linux)     SETTINGS="${XDG_CONFIG_HOME:-$HOME/.config}/Code/User/settings.json" ;;
  Darwin)    SETTINGS="$HOME/Library/Application Support/Code/User/settings.json" ;;
  CYGWIN*|MINGW*) SETTINGS="${APPDATA:-$HOME/AppData/Roaming}/Code/User/settings.json" ;;
  *)         SETTINGS="${XDG_CONFIG_HOME:-$HOME/.config}/Code/User/settings.json" ;;
esac
[[ -f $SETTINGS ]] && cp "$SETTINGS" "${SETTINGS}.bak.$(date +%s)"

# Add ext to settingsSync.ignoredExtensions
add_ignore() {
  local ext="$1" tmp
  [[ -f $SETTINGS ]] || { mkdir -p "${SETTINGS%/*}"; echo '{}' >"$SETTINGS"; }
  tmp=$(mktemp)
  jq --arg ext "$ext" '
    .settingsSync |= (.//{}) |
    .settingsSync.ignoredExtensions |= ((.//[]) + (if index($ext) then [] else [$ext] end))
  ' "$SETTINGS" >"$tmp" && mv "$tmp" "$SETTINGS"
  echo "✏️  Ignored in Sync: $ext"
}

# Unified installer for both CLI & VSIX
install_vsix() {
  local pathOrExt="$1" ext="$2" src="$3"
  local out status

  if [[ "$pathOrExt" == "$ext" ]]; then
    echo "⬇️ [$src] Installing $ext"
    out=$(code --install-extension "$ext" 2>&1) && status=0 || status=$?
  else
    echo "⬇️ [$src] Installing VSIX $pathOrExt"
    out=$(code --install-extension "$pathOrExt" 2>&1) && status=0 || status=$?
  fi

  if grep -qi "not compatible" <<<"$out"; then
    echo "⚠️ $ext is not compatible with this VS Code. Skipping."
    [[ "$pathOrExt" != "$ext" ]] && rm -f "$pathOrExt"
    return 0
  fi

  if [ $status -eq 0 ] && ! grep -qi "not found" <<<"$out"; then
    echo "✅ Installed $ext from $src"
    [[ "$pathOrExt" != "$ext" ]] && rm -f "$pathOrExt"
    if $SUPPORT_ENABLE; then
      code --enable-extension "$ext" &>/dev/null \
        && echo "🔓 Enabled $ext" \
        || echo "⚠️ Failed to enable $ext"
    fi
    return 0
  fi

  echo "⚠️ Install via $src failed for $ext"
  [[ "$pathOrExt" != "$ext" ]] && rm -f "$pathOrExt"
  return 1
}

# Fallback #1: Open VSX VSIX
install_open_vsx() {
  local ext="$1" pub=${ext%%.*} nm=${ext#*.}
  local plat vsix meta url
  case "$(uname -s)-$(uname -m)" in
    Linux-x86_64)   plat="linux-x64";;
    Linux-arm64)    plat="linux-arm64";;
    Darwin-x86_64)  plat="darwin-x64";;
    Darwin-arm64)   plat="darwin-arm64";;
    CYGWIN*|MINGW*) plat="win32-x64";;
    *)              plat="linux-x64";;
  esac

  echo "⬇️ [Open VSX] Fetching metadata for $ext"
  meta=$(curl -fsSL "https://open-vsx.org/api/${pub}/${nm}/latest") || return 1
  url=$(echo "$meta" \
    | jq -r --arg p "$plat" '.downloads[$p] // .files.download')
  [[ $url == https://* ]] || return 1

  vsix="${pub}.${nm}.openvsx.vsix"
  echo "⬇️ [Open VSX] Downloading VSIX → $url"
  curl -fsSL -o "$vsix" "$url" || { rm -f "$vsix"; return 1; }

  install_vsix "$vsix" "$ext" "Open VSX"
}

# Fallback #2: Official Marketplace VSIX (compatible version)
install_marketplace_vsix() {
  local ext="$1"
  local pub=${ext%%.*} nm=${ext#*.}
  local response
  echo "⬇️ [Marketplace VSIX] Fetching metadata for $ext"
  response=$(fetch_extension_metadata "$ext") || return 1

  # get local VS Code semver (strip suffixes)
  local code_ver
  code_ver=$(code --version | head -n1 | sed -E 's/(-.+)?$//')

  # collect compatible versions
  local versions=()
  while IFS=$'\t' read -r ver eng; do
    local min="${eng#^}"
    min=${min:-"0.0.0"}
    if [[ "$(printf '%s\n%s\n' "$min" "$code_ver" | sort -V | head -1)" == "$min" ]]; then
      versions+=("$ver")
    fi
  done < <(
    echo "$response" \
    | jq -r '
        .results[0].extensions[0].versions[]
        | "\(.version)\t\((.properties[]? 
             | select(.key=="Microsoft.VisualStudio.Code.Engine").value) // "")"
      '
  )

  if (( ${#versions[@]} == 0 )); then
    echo "⚠️ No compatible marketplace version for $ext (Code $code_ver)"
    return 1
  fi

  # pick highest version
  IFS=$'\n' sorted=($(printf "%s\n" "${versions[@]}" | sort -V))
  local chosen=${sorted[-1]}

  local vsix_url="https://${pub}.gallery.vsassets.io/_apis/public/gallery/publisher/${pub}/extension/${nm}/${chosen}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
  local vsix="${pub}.${nm}.mp.vsix"
  echo "⬇️ [Marketplace VSIX] Downloading $chosen → $vsix_url"
  curl -fsSL -o "$vsix" "$vsix_url" || { rm -f "$vsix"; return 1; }

  install_vsix "$vsix" "$ext" "Marketplace VSIX"
}

# Market­place metadata fetcher
fetch_extension_metadata() {
  local extension_id="$1"
  local api_url="https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery"
  local payload flags=16863
  payload=$(
    jq -c -n --arg id "$extension_id" --argjson f "$flags" '
      {filters:[{criteria:[{filterType:7,value:$id}],pageNumber:1,pageSize:1,sortBy:0,sortOrder:0}],flags:$f}
    '
  )
  curl -s -H "Content-Type: application/json" \
           -H "Accept: application/json; api-version=7.2-preview.1" \
           -H "User-Agent: VSCodeExtInstaller" \
           -d "$payload" "$api_url"
}

# ────────────────────────────────────────────────────────────────────────────────
# Main loop
echo "🔍 Processing ${#RECS[@]} extension(s)…"
for ext in "${RECS[@]}"; do
  echo -e "\n🔎 $ext"
  add_ignore "$ext"

  # skip if already installed
  elc=${ext,,}
  if printf '%s\n' "${INSTALLED[@]}" | grep -qx "$elc"; then
    echo "✅ Already installed"
    $SUPPORT_ENABLE && code --enable-extension "$ext" &>/dev/null && echo "🔓 Enabled $ext"
    continue
  fi

  # 1) Marketplace CLI
  install_vsix "$ext" "$ext" "Marketplace CLI" && continue

  # 2) Open VSX fallback
  install_open_vsx "$ext" && continue

  # 3) Marketplace VSIX (compatible version)
  install_marketplace_vsix "$ext" && continue

  echo "❌ All install strategies failed for $ext"
done

echo -e "\n🎉 Done. Extensions installed/enabled locally and ignored by Settings Sync."
