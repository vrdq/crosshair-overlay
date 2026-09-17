ifeq ($(shell id -u), 0)
    PREFIX ?= /usr/local
else
    PREFIX ?= $(HOME)/.local
endif

BINDIR ?= $(PREFIX)/bin
DATADIR ?= $(PREFIX)/share
DESKTOPDIR ?= $(DATADIR)/applications
ICONDIR ?= $(DATADIR)/icons/hicolor/scalable/apps

all:
	$(MAKE) -C src

install: all
	install -Dm755 src/crosshair $(DESTDIR)$(BINDIR)/crosshair
	install -Dm755 crosshair-gui $(DESTDIR)$(BINDIR)/crosshair-gui
	install -Dm644 data/crosshair.desktop $(DESTDIR)$(DESKTOPDIR)/crosshair.desktop
	install -Dm644 data/crosshair.svg $(DESTDIR)$(ICONDIR)/crosshair.svg
	@command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database $(DESTDIR)$(DESKTOPDIR) || true
	@command -v gtk-update-icon-cache >/dev/null 2>&1 && gtk-update-icon-cache -f -t $(DESTDIR)$(DATADIR)/icons/hicolor 2>/dev/null || true
	@echo "Installed crosshair and crosshair-gui to $(DESTDIR)$(BINDIR)"

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/crosshair
	rm -f $(DESTDIR)$(BINDIR)/crosshair-gui
	rm -f $(DESTDIR)$(DESKTOPDIR)/crosshair.desktop
	rm -f $(DESTDIR)$(ICONDIR)/crosshair.svg
	@command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database $(DESTDIR)$(DESKTOPDIR) || true
	@command -v gtk-update-icon-cache >/dev/null 2>&1 && gtk-update-icon-cache -f -t $(DESTDIR)$(DATADIR)/icons/hicolor 2>/dev/null || true

clean:
	$(MAKE) -C src clean

.PHONY: all install uninstall clean
