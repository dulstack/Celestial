CURDIR = set_oxygen_theme
.PHONY: set_oxygen_theme-all set_oxygen_theme-build set_oxygen_theme-install

set_oxygen_theme-all: set_oxygen_theme-build set_oxygen_theme-install
set_oxygen_theme-build: $(CHROOT)/usr/local/bin/set_oxygen_theme.elf
set_oxygen_theme-install:
	mkdir -p $(CHROOT)/etc/systemd/system
	cd $(CURDIR);\
	 cp root/etc/systemd/system/set_oxygen_theme.service \
	  $(CHROOT)/etc/systemd/system/

$(CHROOT)/usr/local/bin/set_oxygen_theme.elf: $(CURDIR)/set_oxygen_theme.c
	mkdir -p $(CHROOT)/usr/local/bin
	$(CC) -o $@ -s $<
