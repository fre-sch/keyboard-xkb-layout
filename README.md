# keyboard-xkb-layout

custom xkb layout

## Install

- Put both files in the same directory and run `sudo ./install-redox-xkb.sh.`
- Test it before committing: `setxkbmap redox`. To revert, run `setxkbmap us`.
- In System Settings → Input Devices → Keyboard → Layouts, add
  "English (Redox)". Keep us as a second layout with a switch shortcut as an 
  escape hatch.
- Under Advanced, make sure no Caps Lock or "3rd level" options are set, since 
  those would override Caps and AltGr.

## Behavior

- With Shift, layer 1 acts like VIA: AltGr+Shift on `;` gives `:`, and on `=`
  gives `+`.
- Empty layer-2 positions (where Copy/Paste/Cut were) and the bottom row of
  layer 1 do nothing.

## Caveats

- With Shift+AltGr+arrow (or Home, End, PgUp, PgDn), XKB treats Shift as used up
  for choosing the level. Some apps then won't see Shift, so text selection may 
  not work everywhere.
- The installer edits evdev.xml, which belongs to the xkb-data / 
  xkeyboard-config package. An update will remove the layout from the list, so
  re-run the script afterwards. The symbols file itself isn't owned by the
  package and survives updates.