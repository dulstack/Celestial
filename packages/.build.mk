PACKAGES          = $(wildcard *)
PACKAGE_MAKEFILES = $(PACKAGES:%=%/build.mk)
PACKAGE_TARGETS   = $(PACKAGES:%=%-all)
CHROOT           ?= $(shell pwd)/../config/includes.chroot
CC     ?= $(CHROOT)/usr/bin/gcc

.PHONY: all

include $(PACKAGE_MAKEFILES)
all: $(PACKAGE_TARGETS)
