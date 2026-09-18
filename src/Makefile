CC ?= gcc
CFLAGS ?= -O3 -Wall -Wextra
PKG_CONFIG ?= pkg-config

DEPS = gtk+-3.0 gtk-layer-shell-0 cairo glib-2.0
CFLAGS += $(shell $(PKG_CONFIG) --cflags $(DEPS))
LIBS = $(shell $(PKG_CONFIG) --libs $(DEPS)) -lm

PREFIX ?= $(HOME)/.local
BINDIR ?= $(PREFIX)/bin

all: cairo

cairo: main.c
	$(CC) $(CFLAGS) $< $(LIBS) -o $@
	ln -sf cairo crosshair

install: cairo
	install -Dm755 cairo $(DESTDIR)$(BINDIR)/cairo
	ln -sf cairo $(DESTDIR)$(BINDIR)/crosshair

clean:
	rm -f cairo crosshair

.PHONY: all install clean
