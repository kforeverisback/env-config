# Setup Instructions

The i3 config is heavily inspired by EndeavourOS's i3 config.
It can be [found here](https://github.com/endeavouros-team/endeavouros-i3wm-setup/blob/main/.config/i3/config).

## Contents
- Launchers:
  - If using `dmenu`: install `dmenu`, `dmenu-frecency`
  - If using `rofi`
    - install `rofi`, `rofi-autorandr`, `rofi-code`
    - Either clone and setup launchers and themes https://github.com/adi1090x/rofi
    - Or use the modified themes from this repo's [`rofi-goodies` directory](../rofi-goodies/)
- Use `i3lock-color` instead of `i3lock`, since the first one supports jpg
- Install `i3status-rs` package (or download and add to PATH)
- Copy/link `/i3config-rs` folder to `.config/` folder 
- Copy/link `i3/config` to `$HOME/.config/i3`
