# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# liboauth
PKG             := liboauth
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.3
$(PKG)_CHECKSUM := a7e5a641d20588d2370062fa3d26201fdcc19aab
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://liboauth.sourceforge.net/
$(PKG)_URL      := http://liboauth.sourceforge.net/pool/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc curl openssl

define $(PKG)_UPDATE
    wget -q -O- 'http://liboauth.sourceforge.net/' | \
    $(SED) -n 's,.*liboauth-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-curl
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
   
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-liboauth.exe' \
        `'$(TARGET)-pkg-config' oauth --cflags --libs`
endef
