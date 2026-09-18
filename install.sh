#!/usr/bin/env bash
set -e

# Cairo Crosshair App installer
# Installs cairo daemon and cairo-gui configuration utility.

BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BOLD}Cairo Crosshair App installer${NC}\n"

# 1. Dependency checks
MISSING_PKGS=()

check_cmd() {
    command -v "$1" >/dev/null 2>&1
}

check_pkg() {
    pkg-config --exists "$1" 2>/dev/null
}

if ! check_cmd gcc && ! check_cmd clang; then
    MISSING_PKGS+=("gcc/clang")
fi

if ! check_cmd make; then
    MISSING_PKGS+=("make")
fi

if ! check_cmd pkg-config; then
    MISSING_PKGS+=("pkg-config")
else
    check_pkg "gtk+-3.0" || MISSING_PKGS+=("gtk3")
    check_pkg "gtk-layer-shell-0" || MISSING_PKGS+=("gtk-layer-shell")
    check_pkg "cairo" || MISSING_PKGS+=("cairo")
    check_pkg "glib-2.0" || MISSING_PKGS+=("glib2")
fi

if ! check_cmd python3; then
    MISSING_PKGS+=("python3")
fi

if ! python3 -c "import PyQt6" 2>/dev/null; then
    MISSING_PKGS+=("python-pyqt6 (for GUI)")
fi

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    echo -e "${YELLOW}Missing required dependencies:${NC}"
    for pkg in "${MISSING_PKGS[@]}"; do
        echo "  - $pkg"
    done
    echo ""

    # Detect package manager
    if check_cmd pacman; then
        echo -e "To install on Arch Linux / CachyOS / Manjaro run:"
        echo -e "  ${BOLD}sudo pacman -S --needed base-devel gtk3 gtk-layer-shell cairo glib2 python python-pyqt6${NC}\n"
    elif check_cmd apt-get; then
        echo -e "To install on Debian / Ubuntu / Mint run:"
        echo -e "  ${BOLD}sudo apt-get update && sudo apt-get install -y build-essential libgtk-3-dev libgtk-layer-shell-dev libcairo2-dev libglib2.0-dev pkg-config python3 python3-pyqt6${NC}\n"
    elif check_cmd dnf; then
        echo -e "To install on Fedora / RHEL run:"
        echo -e "  ${BOLD}sudo dnf install -y gcc make pkgconf-pkg-config gtk3-devel gtk-layer-shell-devel cairo-devel glib2-devel python3 python3-pyqt6${NC}\n"
    elif check_cmd zypper; then
        echo -e "To install on openSUSE run:"
        echo -e "  ${BOLD}sudo zypper install -y gcc make pkg-config gtk3-devel gtk-layer-shell-devel cairo-devel glib2-devel python3 python3-qt6${NC}\n"
    fi

    if [ -t 0 ]; then
        read -r -p "Attempt to install missing packages now with sudo? [y/N] " response
        case "$response" in
            [yY][eE][sS]|[yY])
                if check_cmd pacman; then
                    sudo pacman -S --needed base-devel gtk3 gtk-layer-shell cairo glib2 python python-pyqt6
                elif check_cmd apt-get; then
                    sudo apt-get update && sudo apt-get install -y build-essential libgtk-3-dev libgtk-layer-shell-dev libcairo2-dev libglib2.0-dev pkg-config python3 python3-pyqt6
                elif check_cmd dnf; then
                    sudo dnf install -y gcc make pkgconf-pkg-config gtk3-devel gtk-layer-shell-devel cairo-devel glib2-devel python3 python3-pyqt6
                elif check_cmd zypper; then
                    sudo zypper install -y gcc make pkg-config gtk3-devel gtk-layer-shell-devel cairo-devel glib2-devel python3 python3-qt6
                else
                    echo -e "${RED}Unknown package manager. Please install dependencies manually.${NC}"
                    exit 1
                fi
                ;;
            *)
                echo -e "Please install the missing dependencies and run ./install.sh again."
                exit 1
                ;;
        esac
    else
        echo -e "${RED}Please install dependencies and rerun ./install.sh${NC}"
        exit 1
    fi
fi

# 2. Build cairo binary
echo -e "${BLUE}==>${NC} Building cairo overlay daemon..."
make -C src clean
make -C src

# 3. Install to target directory
if [ "$EUID" -eq 0 ]; then
    PREFIX="${PREFIX:-/usr/local}"
else
    PREFIX="${PREFIX:-$HOME/.local}"
fi

BINDIR="$PREFIX/bin"
DATADIR="$PREFIX/share"
DESKTOPDIR="$DATADIR/applications"
ICONDIR="$DATADIR/icons/hicolor/scalable/apps"

echo -e "${BLUE}==>${NC} Installing to $PREFIX..."
install -Dm755 src/cairo "$BINDIR/cairo"
ln -sf cairo "$BINDIR/crosshair"
install -Dm755 cairo-gui "$BINDIR/cairo-gui"
ln -sf cairo-gui "$BINDIR/crosshair-gui"
install -Dm644 data/cairo.desktop "$DESKTOPDIR/cairo.desktop"
install -Dm644 data/cairo.svg "$ICONDIR/cairo.svg"
install -Dm644 data/crosshair.desktop "$DESKTOPDIR/crosshair.desktop"
install -Dm644 data/crosshair.svg "$ICONDIR/crosshair.svg"

# Update caches
if check_cmd update-desktop-database; then
    update-desktop-database "$DESKTOPDIR" 2>/dev/null || true
fi
if check_cmd gtk-update-icon-cache; then
    gtk-update-icon-cache -f -t "$DATADIR/icons/hicolor" 2>/dev/null || true
fi

# 4. PATH check
PATH_OK=false
IFS=':' read -ra PATH_DIRS <<< "$PATH"
for dir in "${PATH_DIRS[@]}"; do
    if [ "$dir" = "$BINDIR" ]; then
        PATH_OK=true
        break
    fi
done

if [ "$PATH_OK" = false ]; then
    echo -e "\n${YELLOW}Notice: $BINDIR is not currently in your \$PATH.${NC}"
    echo "To run 'cairo' and 'cairo-gui' directly, add it to your shell config:"
    echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
    echo "  # or for zsh:"
    echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc"
    echo "  # or for fish:"
    echo "  fish_add_path ~/.local/bin"
fi

echo -e "\n${GREEN}${BOLD}Installation complete!${NC}"
echo "Installed binaries:"
echo "  $BINDIR/cairo"
echo "  $BINDIR/cairo-gui"
echo "  $BINDIR/crosshair (symlink)"
echo "  $BINDIR/crosshair-gui (symlink)"
echo ""
echo "Quick start:"
echo "  cairo start    # Start overlay in background"
echo "  cairo-gui      # Open configuration dialog"
echo "  cairo toggle   # Toggle on/off"
