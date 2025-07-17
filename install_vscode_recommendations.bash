#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# install_vscode_recommendations.bash
#
# Reads .vscode/extensions.json → recommendations[]
# For each ext:
#   • Adds it to settingsSync.ignoredExtensions
#   • If already installed → skips, then optionally enables
#   • Else tries, in order:
#       1) Marketplace CLI
#       2) Open VSX VSIX
#       3) Official Marketplace VSIX (assetbyname URL)
#   • All installs funnel through install_vsix()
# -----------------------------------------------------------------------------

fail(){ echo "❌ $1" >&2; exit 1; }

# prerequisites
for cmd in jq code curl uname; do
  command -v "$cmd" >/dev/null || fail "'$cmd' is required in PATH"
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
jq empty "$EXT_FILE" 2>/dev/null || fail "$EXT_FILE is invalid JSON"
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
add_ignore(){
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
install_vsix(){
  local pathOrExt="$1" ext="$2" src="$3"
  local out status

  if [[ "$pathOrExt" == "$ext" ]]; then
    # Marketplace CLI
    echo "⬇️ [$src] Installing $ext"
    out=$(code --install-extension "$ext" 2>&1) && status=0 || status=$?
  else
    # VSIX file
    echo "⬇️ [$src] Installing VSIX $pathOrExt"
    out=$(code --install-extension "$pathOrExt" 2>&1) && status=0 || status=$?
  fi

  # compatibility check
  if grep -qi "not compatible" <<<"$out"; then
    echo "⚠️ $ext is not compatible with this VS Code. Skipping."
    [[ "$pathOrExt" != "$ext" ]] && rm -f "$pathOrExt"
    return 0
  fi

  # success if exit=0 AND no “not found” in output
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
install_open_vsx(){
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
  url=$(echo "$meta" | jq -r --arg p "$plat" '.downloads[$p] // .files.download')
  [[ $url == https://* ]] || return 1

  vsix="${pub}.${nm}.openvsx.vsix"
  echo "⬇️ [Open VSX] Downloading VSIX → $url"
  curl -fsSL -o "$vsix" "$url" || { rm -f "$vsix"; return 1; }

  install_vsix "$vsix" "$ext" "Open VSX"
}

# Fallback #2: Official Marketplace VSIX via assetbyname
install_marketplace_vsix(){
  local ext="$1" pub=${ext%%.*} nm=${ext#*.}
  local vsix="${pub}.${nm}.mp.vsix"
  local url="https://${pub}.gallery.vsassets.io/_apis/public/gallery/publisher/${pub}/extension/${nm}/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"

  echo "⬇️ [Marketplace VSIX] Downloading → $url"
  curl -fsSL -o "$vsix" "$url" || return 1
  install_vsix "$vsix" "$ext" "Marketplace VSIX"
}

# Main loop
echo "🔍 Processing ${#RECS[@]} extension(s)…"
for ext in "${RECS[@]}"; do
  echo -e "\n🔎 $ext"
  add_ignore "$ext"

  # skip if already installed
  elc=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
  if printf '%s\n' "${INSTALLED[@]}" | grep -qx "$elc"; then
    echo "✅ Already installed"
    if $SUPPORT_ENABLE; then
      code --enable-extension "$ext" &>/dev/null && echo "🔓 Enabled $ext"
    fi
    continue
  fi

  # 1) Marketplace CLI
  install_vsix "$ext" "$ext" "Marketplace CLI" && continue

  # 2) Open VSX fallback
  install_open_vsx "$ext" && continue

  # 3) Official Marketplace VSIX fallback
  install_marketplace_vsix "$ext" && continue

  echo "❌ All install strategies failed for $ext"
done

echo -e "\n🎉 Done. Extensions installed/enabled locally and ignored by Settings Sync."
