PREFIX ?= $(HOME)/.local
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

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/crosshair
	rm -f $(DESTDIR)$(BINDIR)/crosshair-gui
	rm -f $(DESTDIR)$(DESKTOPDIR)/crosshair.desktop
	rm -f $(DESTDIR)$(ICONDIR)/crosshair.svg

clean:
	$(MAKE) -C src clean

.PHONY: all install uninstall clean
