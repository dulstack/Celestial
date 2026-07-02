CURDIR = set_oxygen_theme
.PHONY: set_oxygen_theme-all set_oxygen_theme-build set_oxygen_theme-install\
	set_oxygen_theme-clean

.NOTPARALELL: set_oxygen_theme-all
set_oxygen_theme-all: set_oxygen_theme-build set_oxygen_theme-install
set_oxygen_theme-build: $(CHROOT)/usr/local/bin/set_oxygen_theme.elf

set_oxygen_theme-install:
	mkdir -p $(CHROOT)/usr/lib/systemd/system $(INCLUDES_BINARY_DIR)
	cd $(CURDIR);\
	 cp -r root/* \
	  $(CHROOT)/

$(CHROOT)/usr/local/bin/set_oxygen_theme.elf: $(CURDIR)/set_oxygen_theme.c
	mkdir -p $(CHROOT)/usr/local/bin
	$(CC) -o $@ -s $<
set_oxygen_theme-clean:
