# crosshair-overlay

Screen crosshair overlay daemon for Wayland compositors (Hyprland, Sway, River) written in C using `gtk-layer-shell` and Cairo, with a native Qt settings utility (`crosshair-gui`).

## How It Works

Unlike X11 overlays or utilities running through XWayland, `crosshair-overlay` binds directly to the Wayland `overlay` layer surface with input passthrough enabled. Clicks and mouse motion pass straight through to the underlying game without added latency.

Reticles (dot, hollow ring, dot-ring, cross, and cross-dot) are drawn using Cairo with anti-aliasing. The daemon listens for `SIGUSR1` and `SIGHUP` signals, reloading configuration from disk without restarting the process.

## Installation

### Dependencies

On Arch Linux / CachyOS / Manjaro:
```bash
sudo pacman -S base-devel gtk3 gtk-layer-shell cairo glib2 python python-pyqt6
```

On Debian / Ubuntu / Linux Mint:
```bash
sudo apt-get update && sudo apt-get install -y build-essential libgtk-3-dev libgtk-layer-shell-dev libcairo2-dev libglib2.0-dev pkg-config python3 python3-pyqt6
```

On Fedora:
```bash
sudo dnf install -y gcc make pkgconf-pkg-config gtk3-devel gtk-layer-shell-devel cairo-devel glib2-devel python3 python3-pyqt6
```

### Install with install.sh

```bash
git clone https://github.com/vrdq/crosshair-overlay.git
cd crosshair-overlay
./install.sh
```

The script checks dependencies, compiles `src/crosshair`, installs binaries to `~/.local/bin`, installs the desktop entry and icon, and verifies your PATH.

### Manual Build

```bash
make
make install
```

To install system-wide to `/usr/local`:
```bash
sudo make install
```

To uninstall:
```bash
make uninstall
```

## Usage

### Command Line

```bash
crosshair start    # Start overlay daemon in the background
crosshair stop     # Terminate running overlay
crosshair toggle   # Toggle crosshair on/off
crosshair reload   # Reload configuration from disk
crosshair status   # Check daemon running state and PID
crosshair --help   # Show options
```

### Settings GUI

```bash
crosshair-gui
```

You can also launch **Crosshair Overlay** from your application launcher (Rofi, Wofi, Walker, or KDE KRunner).

## Configuration

Settings are saved in plain text at `~/.config/crosshair/config`:

```ini
shape = dot
size = 6.0
color = #00FF00
outline = 1.0
outline_color = #000000
opacity = 1.00
offset_x = 0
offset_y = 0
gap = 3
length = 7
thickness = 2
monitor = all
```

### Options

- `shape`: `dot`, `ring`, `dot-ring`, `cross`, or `cross-dot`
- `size`: diameter or bounding size in pixels (default `6.0`)
- `color`: hex color code (default `#00FF00`)
- `outline`: border stroke thickness in pixels (default `1.0`, `0` to disable)
- `outline_color`: border hex color (default `#000000`)
- `opacity`: opacity from `0.1` to `1.0` (default `1.0`)
- `offset_x`: horizontal pixel offset from screen center
- `offset_y`: vertical pixel offset from screen center
- `gap`: center gap in pixels for cross reticles
- `length`: arm length in pixels for cross reticles
- `thickness`: stroke thickness for cross arms and hollow rings
- `monitor`: `all` or a specific monitor identifier (e.g. `DP-1`)

## Compositor Setup

### Hyprland

Add to `~/.config/hypr/hyprland.conf`:

```ini
# Toggle crosshair with Super + Alt + C
bind = $mainMod ALT, C, exec, crosshair toggle

# Float configuration window
windowrulev2 = float, class:^(crosshair|crosshair-gui|CrosshairSettingsDialog)$
```

### Sway

Add to `~/.config/sway/config`:

```ini
bindsym $mod+Mod1+c exec crosshair toggle
for_window [app_id="crosshair-gui"] floating enable
```

## License

MIT
