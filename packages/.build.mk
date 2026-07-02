PACKAGES              = $(wildcard *)
PACKAGE_MAKEFILES     = $(PACKAGES:%=%/build.mk)
PACKAGE_TARGETS       = $(PACKAGES:%=%-all)
PACKAGE_CLEAN_TARGETS = $(PACKAGES:%=%-clean)
CHROOT               ?= $(shell pwd)/.rootfs
INCLUDES_BINARY_DIR   = $(shell pwd)/../config/includes.binary
CC                   ?= $(CHROOT)/usr/bin/gcc

.PHONY: all clean

all: $(PACKAGE_TARGETS) .binary_stamp

include $(PACKAGE_MAKEFILES)

.binary_stamp:
	mkdir -p $(CHROOT)/var/lib/flatpak/ $(INCLUDES_BINARY_DIR)
	cd $(shell pwd)/../;\
	 dpkg-deb --root-owner-group --build $(CHROOT)/ \
	  $(INCLUDES_BINARY_DIR)/set-oxygen-theme.deb;\
	 lb config;\
	 lb bootstrap;\
	 lb chroot;\
	 lb installer;\
	 lb binary
	touch $@

clean: $(PACKAGE_CLEAN_TARGETS)
	cd $(shell pwd)/../;\
	 lb clean
	rm -rf $(CHROOT) $(INCLUDES_BINARY_DIR) .binary_stamp
