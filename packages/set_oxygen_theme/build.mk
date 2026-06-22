CURDIR = set_oxygen_theme
.PHONY: set_oxygen_theme-all set_oxygen_theme-build set_oxygen_theme-install

.NOTPARALELL: 
set_oxygen_theme-all: set_oxygen_theme-build set_oxygen_theme-install
set_oxygen_theme-build: $(CHROOT)/usr/local/bin/set_oxygen_theme.elf

set_oxygen_theme-install:
	mkdir -p $(CHROOT)/usr/lib/systemd/system $(CHROOT)/../includes.binary
	cd $(CURDIR);\
	 cp root/usr/lib/systemd/system/set_oxygen_theme.service \
	  $(CHROOT)/usr/lib/systemd/system/;\
	 cp -r root/DEBIAN $(CHROOT)/
	dpkg-deb --root-owner-group --build $(CHROOT)/ \
	 $(CHROOT)/../includes.binary/set-oxygen-theme.udeb

$(CHROOT)/usr/local/bin/set_oxygen_theme.elf: $(CURDIR)/set_oxygen_theme.c
	mkdir -p $(CHROOT)/usr/local/bin
	$(CC) -o $@ -s $<
