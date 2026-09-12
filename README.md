# crosshair-overlay

A lightweight, zero-latency screen crosshair overlay daemon and configuration utility for Wayland compositors (Hyprland, Sway, Wayfire, River).

Built in C using `gtk-layer-shell` and Cairo, paired with a native Qt configuration dialog.

---

## Features

- **True Wayland Layer Surface**: Uses the Wayland `layer-shell` protocol to render an input-transparent, click-through overlay on the `overlay` layer.
- **Zero Input Interference**: Input passthrough enabled by default; never intercepts mouse clicks, keyboard input, or cursor movement.
- **Instant Hot-Reload**: Supports live reload without restarting the process via `SIGUSR1` or the CLI (`crosshair reload`).
- **Reticle Geometries**: Dot, hollow ring, dot + ring, classic cross, and cross + center dot.
- **Subpixel & Offset Control**: Fine-grained adjustments for size, line thickness, center gap, line length, outline stroke, outline color, opacity, and X/Y pixel offsets.
- **Multi-Monitor Support**: Target all connected monitors simultaneously or bind to a specific display.
- **Native Qt Settings GUI**: Clean, system-themed configuration utility (`crosshair-gui`) built with standard Qt widgets matching Breeze/KDE/system palettes without hardcoded CSS.
- **Desktop & Launcher Integration**: Ships with an XDG `.desktop` entry, actions (`Toggle`, `Start`, `Stop`), and an SVG scalable icon.

---

## Requirements

### Build Dependencies

- C compiler (`gcc` or `clang`)
- `make`
- `pkg-config`
- `gtk3`
- `gtk-layer-shell`
- `cairo`
- `glib2`

### GUI Requirements

- Python 3
- `python-pyqt6` (Arch: `sudo pacman -S python-pyqt6`)

### On Arch Linux:

```bash
sudo pacman -S base-devel gtk3 gtk-layer-shell cairo glib2 python-pyqt6
```

---

## Installation

Clone the repository and build:

```bash
git clone https://github.com/vrdq/crosshair-overlay.git
cd crosshair-overlay
make
```

Install to user bin directory (`~/.local/bin` and `~/.local/share`):

```bash
make install
```

To install system-wide (`/usr/local`):

```bash
sudo make PREFIX=/usr/local install
```

To uninstall:

```bash
make uninstall
```

---

## Usage

### Command Line Interface

```bash
crosshair start    # Start overlay daemon in the background
crosshair stop     # Terminate running overlay
crosshair toggle   # Toggle crosshair on/off
crosshair reload   # Send SIGUSR1 to reload configuration instantly
crosshair status   # Check daemon running state and PID
crosshair --help   # Show CLI help
```

### Configuration GUI

Launch the native configuration dialog:

```bash
crosshair-gui
```

You can also launch **Screen Crosshair** from your application launcher (Spotlight, Rofi, Wofi, Walker, or KDE KRunner).

---

## Configuration

Configuration is stored in plain text at:

```
~/.config/crosshair/config
```

Example configuration file:

```ini
# Crosshair Overlay Configuration
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

### Configuration Keys

| Key | Type | Default | Description |
|---|---|---|---|
| `shape` | string | `dot` | Reticle shape: `dot`, `ring`, `dot-ring`, `cross`, `cross-dot` |
| `size` | float | `6.0` | Outer size / diameter in pixels |
| `color` | hex | `#00FF00` | Hex reticle color |
| `outline` | float | `1.0` | Outline border thickness in pixels (`0` to disable) |
| `outline_color` | hex | `#000000` | Hex outline border color |
| `opacity` | float | `1.0` | Reticle opacity (`0.0` to `1.0`) |
| `offset_x` | int | `0` | Horizontal pixel offset from screen center |
| `offset_y` | int | `0` | Vertical pixel offset from screen center |
| `gap` | int | `3` | Center gap for crosshair bars |
| `length` | int | `7` | Length of crosshair arms |
| `thickness` | int | `2` | Stroke thickness for crosshair arms/ring |
| `monitor` | string | `all` | Display target (`all` or specific monitor name) |

---

## Compositor Integration

### Hyprland

Add a keybinding to `~/.config/hypr/hyprland.conf`:

```ini
# Toggle crosshair on/off with Super + Alt + C
bind = $mainMod ALT, C, exec, crosshair toggle

# Ensure configuration window floats
windowrulev2 = float, class:^(crosshair-gui|CrosshairSettingsDialog)$, title:^(Crosshair Settings)$
```

### Sway

Add to `~/.config/sway/config`:

```ini
bindsym $mod+Mod1+c exec crosshair toggle
for_window [app_id="crosshair-gui"] floating enable
```

---

## License

MIT
