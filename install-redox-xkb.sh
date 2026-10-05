#!/bin/bash
# Install/uninstall the "redox" XKB layout system-wide.
# Usage: sudo ./install-redox-xkb.sh [--uninstall]
set -euo pipefail

XKB=/usr/share/X11/xkb
SYM="$XKB/symbols/redox"
XML="$XKB/rules/evdev.xml"
HERE="$(cd "$(dirname "$0")" && pwd)"

[[ $EUID -eq 0 ]] || { echo "Run as root." >&2; exit 1; }

if [[ "${1:-}" == "--uninstall" ]]; then
    rm -f "$SYM"
    sed -i --follow-symlinks '/<!-- redox-begin -->/,/<!-- redox-end -->/d' "$XML"
    echo "Removed. Switch KDE back to another layout before logging out."
    exit 0
fi

install -m 644 "$HERE/redox" "$SYM"

if ! grep -q '<!-- redox-begin -->' "$XML"; then
    cp -a "$XML" "$XML.bak-redox"
    sed -i --follow-symlinks '0,/<layoutList>/s||<layoutList>\
    <!-- redox-begin -->\
    <layout>\
      <configItem>\
        <name>redox</name>\
        <shortDescription>rdx</shortDescription>\
        <description>English (Redox)</description>\
        <languageList><iso639Id>eng</iso639Id></languageList>\
      </configItem>\
    </layout>\
    <!-- redox-end -->|' "$XML"
fi

# Sanity check: compile a full keymap with the new layout
printf 'xkb_keymap {
  xkb_keycodes { include "evdev+aliases(qwerty)" };
  xkb_types    { include "complete" };
  xkb_compat   { include "complete" };
  xkb_symbols  { include "pc+redox" };
};\n' | xkbcomp -w 0 - -xkm /dev/null \
    && echo "Installed and compiles. Add 'English (Redox)' in KDE keyboard settings." \
    || { echo "Compile failed." >&2; exit 1; }
