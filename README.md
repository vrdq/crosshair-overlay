# Cairo Crosshair App

Screen reticle and crosshair overlay daemon for Wayland compositors (Hyprland, Sway, River) written in C using `gtk-layer-shell` and Cairo graphics, paired with a native Qt settings utility (`cairo-gui`).

## Identity

**Cairo Crosshair App** is named after two things:
1. The **Cairo 2D vector graphics library** (`libcairo`) used to render anti-aliased subpixel reticles.
2. **Cairo, Egypt**, the developer's home city.

## How It Works

Unlike X11 overlays or utilities running through XWayland, `cairo` binds directly to the Wayland `overlay` layer surface with input passthrough enabled. Clicks and mouse motion pass straight through to the underlying game with zero added latency.

Reticles (dot, hollow ring, dot-ring, cross, and cross-dot) are drawn using Cairo with anti-aliasing. The daemon listens for `SIGUSR1` and `SIGHUP` signals, reloading configuration from disk without restarting the process.

## Installation

### Dependencies

On Arch Linux, CachyOS, and Manjaro:
```bash
sudo pacman -S base-devel gtk3 gtk-layer-shell cairo glib2 python python-pyqt6
```

On Debian, Ubuntu, and Linux Mint:
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

The script checks dependencies, compiles `src/cairo`, installs binaries to `~/.local/bin`, installs the desktop entry and icon, and verifies your PATH.

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
cairo start    # Start overlay daemon in the background
cairo stop     # Terminate running overlay
cairo toggle   # Toggle reticle on or off
cairo reload   # Reload configuration from disk
cairo status   # Check daemon running state and PID
cairo --help   # Show options
```

*Note: `crosshair` is maintained as a symlink to `cairo` for backwards compatibility with existing keybinds.*

### Settings GUI

```bash
cairo-gui
```

You can also launch **Cairo Crosshair App** from your application launcher (Rofi, Wofi, Walker, or KDE KRunner).

## Configuration

Settings are saved in plain text at `~/.config/cairo/config` (with automatic fallback to `~/.config/crosshair/config` if present):

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
- `monitor`: `all` or a specific monitor identifier (such as `DP-1`)

## Compositor Setup

### Hyprland

Add to `~/.config/hypr/hyprland.conf`:

```ini
# Toggle reticle with Super + Alt + C
bind = $mainMod ALT, C, exec, cairo toggle

# Float configuration window
windowrulev2 = float, class:^(cairo|cairo-gui|crosshair|crosshair-gui|CrosshairSettingsDialog)$
```

### Sway

Add to `~/.config/sway/config`:

```ini
bindsym $mod+Mod1+c exec cairo toggle
for_window [app_id="cairo-gui"] floating enable
```

## License

MIT
