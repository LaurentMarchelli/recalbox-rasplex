################################################################################
#
# rasplex
#
################################################################################

RASPLEX_RELEASE = 1.6.2
ifeq ($(BR2_ARCH),"rpi1")
	RASPLEX_VERSION = $(RASPLEX_RELEASE).123-e23a7eef-RPi.arm
else
	RASPLEX_VERSION = $(RASPLEX_RELEASE).123-e23a7eef-RPi2.arm
endif
RASPLEX_SOURCE = RasPlex-$(RASPLEX_VERSION).tar.gz
RASPLEX_SITE = https://github.com/RasPlex/RasPlex/releases/download/$(RASPLEX_RELEASE)
RASPLEX_LICENSE = GPL2
RASPLEX_LICENSE_FILES = COPYING

RASPLEX_TRG_BUILD=$(@D)/os/$(RASPLEX_NAME)
RASPLEX_TAR_BUILD=$(RASPLEX_TRG_BUILD).dsk

# Prepare build directories :
# $(@D)/os/rasplex      (Noobs configuration)
# $(@D)/os/rasplex.dsk  (Partitions extracted)
define RASPLEX_PRE_BUILD_CMDS
	@if test -d $(RASPLEX_TRG_BUILD); then \
		rm -rf $(RASPLEX_TRG_BUILD); \
	fi; \
	mkdir -p $(RASPLEX_TRG_BUILD); \
	cp -r $(RASPLEX_PKGDIR)_resources/rpi/* $(RASPLEX_TRG_BUILD)/; \
	cp -r $(RASPLEX_PKGDIR)_resources/$(BR2_ARCH)/* $(RASPLEX_TRG_BUILD)/; \
	if test -d $(RASPLEX_TAR_BUILD); then \
		rm -rf $(RASPLEX_TAR_BUILD); \
	fi; \
	mkdir -p $(RASPLEX_TAR_BUILD)/plexboot; \
	cp -r $(@D)/3rdparty/bootloader/* $(RASPLEX_TAR_BUILD)/plexboot; \
	cp $(@D)/target/SYSTEM $(RASPLEX_TAR_BUILD)/plexboot/SYSTEM; \
	cp $(@D)/target/KERNEL $(RASPLEX_TAR_BUILD)/plexboot/kernel.img; \
	mkdir -p $(RASPLEX_TAR_BUILD)/plexdata/lost+found;
endef

# Add configuration specifics to rasplex partitions
define RASPLEX_BUILD_CMDS
endef

# Compress partitions into tar.xz
define RASPLEX_POST_BUILD_CMDS
	@for p in `ls -d $(RASPLEX_TAR_BUILD)/*/`; do \
		pushd $$p > /dev/null; \
		tar cfvJ $(RASPLEX_TRG_BUILD)/$$(basename $$p).tar.xz *; \
		popd > /dev/null; \
	done
endef

# Copy the content of the $(RASPLEX_TRG_BUILD) to the target/os/rasplex
RASPLEX_SRC_INSTALL=$(RASPLEX_TRG_BUILD)
RASPLEX_TRG_INSTALL=$(TARGET_DIR)/os/$(RASPLEX_NAME)
define RASPLEX_INSTALL_TARGET_CMDS
	#$(call $(RASPLEX_INSTALL_NOOBS))
	@if test -d $(RASPLEX_TRG_INSTALL); then \
		rm -rf $(RASPLEX_TRG_INSTALL); \
	fi; \
	cp -r $(RASPLEX_SRC_INSTALL) $(RASPLEX_TRG_INSTALL)
endef

RASPLEX_PRE_BUILD_HOOKS += RASPLEX_PRE_BUILD_CMDS
RASPLEX_POST_BUILD_HOOKS += RASPLEX_POST_BUILD_CMDS

$(eval $(generic-package))