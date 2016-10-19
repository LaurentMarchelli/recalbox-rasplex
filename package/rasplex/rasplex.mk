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

#####################################################################
# 			PRE_BUILD : Prepare partition directories
# 	$(@D)/os/rasplex      (Noobs configuration)
# 	$(@D)/os/rasplex.dsk  (Partitions extracted)
#####################################################################
RASPLEX_TRG_BUILD=$(@D)/os/$(RASPLEX_NAME)
RASPLEX_TAR_BUILD=$(RASPLEX_TRG_BUILD).dsk

define RASPLEX_PRE_BUILD_CMDS
	if test -d $(RASPLEX_TRG_BUILD); then \
		rm -rf $(RASPLEX_TRG_BUILD); \
	fi; \
	mkdir -p $(RASPLEX_TRG_BUILD); \
	cp -r $(RASPLEX_PKGDIR)noobs/rpi/* $(RASPLEX_TRG_BUILD)/; \
	cp -r $(RASPLEX_PKGDIR)noobs/$(BR2_ARCH)/* $(RASPLEX_TRG_BUILD)/; \
	if test -d $(RASPLEX_TAR_BUILD); then \
		rm -rf $(RASPLEX_TAR_BUILD); \
	fi; \
	mkdir -p $(RASPLEX_TAR_BUILD)/plexboot; \
	cp -r $(@D)/3rdparty/bootloader/* $(RASPLEX_TAR_BUILD)/plexboot; \
	cp $(@D)/target/* $(RASPLEX_TAR_BUILD)/plexboot/; \
	mv $(RASPLEX_TAR_BUILD)/plexboot/KERNEL $(RASPLEX_TAR_BUILD)/plexboot/kernel.img; \
	mv $(RASPLEX_TAR_BUILD)/plexboot/KERNEL.md5 $(RASPLEX_TAR_BUILD)/plexboot/kernel.img.md5; \
	mkdir -p $(RASPLEX_TAR_BUILD)/plexdata/backup;
endef

#####################################################################
# 			BUILD : Customize partition directories
#####################################################################
# Powerswitch configuration
RASPLEX_POWER_PATH = $(RASPLEX_TAR_BUILD)/plexdata/.cache/services
define RASPLEX_BUILD_POWER_CMD
	if [ '$(BR2_ARCH_POWERSWITCH_REMOTEPI_2013)' ==  'y' ]; then \
		mkdir -p $(RASPLEX_POWER_PATH); \
		echo BOARD_VERSION=\"2013\" > $(RASPLEX_POWER_PATH)/remotepi-board.conf; \
	elif [ '$(BR2_ARCH_POWERSWITCH_REMOTEPI_2015)' ==  'y' ]; then \
		mkdir -p $(RASPLEX_POWER_PATH); \
		echo BOARD_VERSION=\"2015\" > $(RASPLEX_POWER_PATH)/remotepi-board.conf; \
	fi;
endef

# Skin configuration
ifndef BR2_PACKAGE_RASPLEX_SKIN_OPENPHT
	ifdef BR2_PACKAGE_RASPLEX_SKIN_AEONNOX
		RASPLEX_SKIN_NAME = skin.aeon.nox.5
		RASPLEX_SKIN_VERSION = 5.2.3
	endif
	# URL information stored in /storage/.plexht/userdata/Database/Addons15.db
	RASPLEX_SKIN_SITE = https://addons.openpht.tv/openpht-1.6
	RASPLEX_SKIN_FILE = $(RASPLEX_SKIN_NAME)-$(RASPLEX_SKIN_VERSION).zip
	RASPLEX_SKIN_PATH = $(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons
	RASPLEX_USER_PATH = $(RASPLEX_TAR_BUILD)/plexdata/.plexht/userdata
	# Download skin if required by configuration
	RASPLEX_EXTRA_DOWNLOADS = \
		$(RASPLEX_SKIN_SITE)/$(RASPLEX_SKIN_NAME)/$(RASPLEX_SKIN_FILE)
endif

define RASPLEX_BUILD_SKIN_CMD
	if [ '$(BR2_PACKAGE_RASPLEX_SKIN_OPENPHT)' !=  'y' ]; then \
		mkdir -p $(RASPLEX_SKIN_PATH)/; \
		unzip -q -o $(DL_DIR)/$(RASPLEX_SKIN_FILE) -d $(RASPLEX_SKIN_PATH)/; \
		if [ '$(BR2_PACKAGE_RECALBOXOS)' ==  'y' ]; then \
			mkdir -p $(RASPLEX_TAR_BUILD)/plexdata/.recalplex/; \
			cp -r $(RASPLEX_PKGDIR)recalplex/* $(RASPLEX_TAR_BUILD)/plexdata/.recalplex/; \
			cp -r $(RASPLEX_TAR_BUILD)/plexdata/.recalplex/addons/$(RASPLEX_SKIN_NAME)/* \
				$(RASPLEX_SKIN_PATH)/$(RASPLEX_SKIN_NAME)/; \
			mkdir -p $(RASPLEX_USER_PATH); \
			cp -r $(RASPLEX_TAR_BUILD)/plexdata/.recalplex/userdata/$(RASPLEX_SKIN_NAME)/* \
				$(RASPLEX_USER_PATH)/; \
			cat $(RASPLEX_PKGDIR)noobs/partition_setup.txt >> $(RASPLEX_TRG_BUILD)/partition_setup.sh; \
		fi; \
	fi;
endef

define RASPLEX_BUILD_CMDS
	$(call RASPLEX_BUILD_POWER_CMD)
	$(call RASPLEX_BUILD_SKIN_CMD)
endef

#####################################################################
# 	POST_BUILD : Compress partitions directories into tar.xz
#####################################################################
define RASPLEX_POST_BUILD_CMDS
	for p in `ls -d $(RASPLEX_TAR_BUILD)/*/`; do \
		pushd $$p > /dev/null; \
		tar cfvJ $(RASPLEX_TRG_BUILD)/$$(basename $$p).tar.xz . --owner=0 --group=0; \
		popd > /dev/null; \
	done
endef

RASPLEX_PRE_BUILD_HOOKS += RASPLEX_PRE_BUILD_CMDS
RASPLEX_POST_BUILD_HOOKS += RASPLEX_POST_BUILD_CMDS

#####################################################################
# 	INSTALL : Copy the content of the $(RASPLEX_TRG_BUILD)
#	          to the target/os/rasplex
#####################################################################
RASPLEX_SRC_INSTALL=$(RASPLEX_TRG_BUILD)
RASPLEX_TRG_INSTALL=$(TARGET_DIR)/os/$(RASPLEX_NAME)
define RASPLEX_INSTALL_TARGET_CMDS
	#$(call $(RASPLEX_INSTALL_NOOBS))
	if test -d $(RASPLEX_TRG_INSTALL); then \
		rm -rf $(RASPLEX_TRG_INSTALL); \
	fi; \
	cp -r $(RASPLEX_SRC_INSTALL) $(RASPLEX_TRG_INSTALL);
endef

$(eval $(generic-package))