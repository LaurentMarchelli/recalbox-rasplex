################################################################################
#
# rasplex
#
################################################################################

RASPLEX_RELEASE = 1.0.3
ifeq ($(BR2_ARCH),"rpi1")
	RASPLEX_VERSION = RPi.RP-$(RASPLEX_RELEASE)
else
	RASPLEX_VERSION = RPi2.RP-$(RASPLEX_RELEASE)
endif
RASPLEX_SOURCE = RasPlex-$(RASPLEX_VERSION).tar.gz
RASPLEX_SITE = https://github.com/RasPlex/RasPlex/releases/download/$(RASPLEX_RELEASE)
RASPLEX_LICENSE = GPL2
RASPLEX_LICENSE_FILES = COPYING

#define RASPLEX_EXTRACT_CMDS
#	unzip -q -o $(DL_DIR)/$(RASPLEX_SOURCE) -d $(@D)/rasplex
#endef

RASPLEX_TRG_BUILD=$(@D)/os/$(RASPLEX_NAME)
RASPLEX_TAR_BUILD=$(@D)/os.tar

define RASPLEX_BUILD_CMDS
	if test -d $(RASPLEX_TAR_BUILD); then \
		rm -rf $(RASPLEX_TAR_BUILD); \
	fi; \
	mkdir -p $(RASPLEX_TAR_BUILD)/plexboot $(RASPLEX_TAR_BUILD)/plexdata; \
	cp -r $(@D)/3rdparty/bootloader/* $(RASPLEX_TAR_BUILD)/plexboot; \
	cp $(@D)/target/SYSTEM $(RASPLEX_TAR_BUILD)/plexboot/SYSTEM; \
	cp $(@D)/target/KERNEL $(RASPLEX_TAR_BUILD)/plexboot/kernel.img; \
	if test -d $(RASPLEX_TRG_BUILD); then \
		rm -rf $(RASPLEX_TRG_BUILD); \
	fi; \
	mkdir -p $(RASPLEX_TRG_BUILD); \
	cp -r $(RASPLEX_PKGDIR)_resources/rpi/* $(RASPLEX_TRG_BUILD)/; \
	cp -r $(RASPLEX_PKGDIR)_resources/$(BR2_ARCH)/* $(RASPLEX_TRG_BUILD)/;
endef

RASPLEX_SRC_INSTALL=$(RASPLEX_TRG_BUILD)
RASPLEX_TRG_INSTALL=$(TARGET_DIR)/os/$(RASPLEX_NAME)

define RASPLEX_INSTALL_TARGET_CMDS
	#$(call $(RASPLEX_INSTALL_NOOBS))
	@if test -d $(RASPLEX_TRG_INSTALL); then \
		rm -rf $(RASPLEX_TRG_INSTALL); \
	fi; \
	cp -r $(RASPLEX_SRC_INSTALL) $(RASPLEX_TRG_INSTALL)
endef

$(eval $(generic-package))