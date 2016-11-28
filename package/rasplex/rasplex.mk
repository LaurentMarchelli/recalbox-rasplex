################################################################################
#
# rasplex
#
################################################################################
RASPLEX_RELEASE = 1.7.1
OPENPHT_BUILD_NUMBER = 137
OPENPHT_GIT_COMMIT = b604995c
ifeq ($(BR2_ARCH),"rpi1")
	RASPLEX_VERSION = $(RASPLEX_RELEASE).$(OPENPHT_BUILD_NUMBER)-$(OPENPHT_GIT_COMMIT)-RPi.arm
else
	RASPLEX_VERSION = $(RASPLEX_RELEASE).$(OPENPHT_BUILD_NUMBER)-$(OPENPHT_GIT_COMMIT)-RPi2.arm
endif
RASPLEX_SOURCE = RasPlex-$(RASPLEX_VERSION).tar.gz
RASPLEX_SITE = https://github.com/RasPlex/RasPlex/releases/download/$(RASPLEX_RELEASE)
RASPLEX_LICENSE = GPL2
RASPLEX_LICENSE_FILES = COPYING

#####################################################################
# 	CONFIGURE : Create noobs os directory for selected rpi
# 	$(@D)/os/rasplex (Noobs configuration)
#####################################################################
RASPLEX_TRG_BUILD=$(@D)/os/$(RASPLEX_NAME)

define RASPLEX_CONFIGURE_CMDS
	########## Create os/$(RECALBOXOS_NAME) for $(BR2_ARCH) ##########
	rm -rf $(RASPLEX_TRG_BUILD); \
	mkdir -p $(RASPLEX_TRG_BUILD); \
	cp -r $(RASPLEX_PKGDIR)noobs/rpi/* $(RASPLEX_TRG_BUILD)/; \
	cp -r $(RASPLEX_PKGDIR)noobs/$(BR2_ARCH)/* $(RASPLEX_TRG_BUILD)/;
endef

#####################################################################
# 	PRE_BUILD : Prepare partition directories
# 	$(@D)/os/rasplex.dsk/* (Partitions extracted)
#####################################################################
RASPLEX_TAR_BUILD = $(RASPLEX_TRG_BUILD).dsk

RASPLEX_PARTITIONS = plexboot plexdata

define RASPLEX_PRE_BUILD_CMDS
	########## Create tar directory for customization ##########
	rm -rf $(RASPLEX_TAR_BUILD); \
	mkdir -p $(RASPLEX_TAR_BUILD)/plexboot; \
	cp -r $(@D)/3rdparty/bootloader/* $(RASPLEX_TAR_BUILD)/plexboot; \
	cp $(@D)/target/* $(RASPLEX_TAR_BUILD)/plexboot/; \
	mv $(RASPLEX_TAR_BUILD)/plexboot/KERNEL $(RASPLEX_TAR_BUILD)/plexboot/kernel.img; \
	mv $(RASPLEX_TAR_BUILD)/plexboot/KERNEL.md5 $(RASPLEX_TAR_BUILD)/plexboot/kernel.img.md5; \
	mkdir -p $(RASPLEX_TAR_BUILD)/plexdata/backup;
endef

#####################################################################
# 	BUILD : Customize partition directories
#####################################################################
RASPLEX_POWER_PATH = $(RASPLEX_TAR_BUILD)/plexdata/.cache/services
define RASPLEX_BUILD_POWER_CMD
	########## Apply Powerswitch configuration ##########
	$(if $(BR2_ARCH_POWERSWITCH_REMOTEPI_2013), \
		mkdir -p $(RASPLEX_POWER_PATH); \
		echo BOARD_VERSION=\"2013\" > $(RASPLEX_POWER_PATH)/remotepi-board.conf; \
	)
	$(if $(BR2_ARCH_POWERSWITCH_REMOTEPI_2015), \
		mkdir -p $(RASPLEX_POWER_PATH); \
		echo BOARD_VERSION=\"2015\" > $(RASPLEX_POWER_PATH)/remotepi-board.conf; \
	)
endef

# Skin configuration for AeonNox
ifdef BR2_PACKAGE_RASPLEX_SKIN_AEONNOX
	RASPLEX_SKIN_NAME = skin.aeon.nox.5
	RASPLEX_SKIN_VERSION = 5.2.3
	# URL information stored in /storage/.plexht/userdata/Database/Addons15.db
	RASPLEX_SKIN_SITE = https://addons.openpht.tv/openpht-1.6
	RASPLEX_SKIN_FILE = $(RASPLEX_SKIN_NAME)-$(RASPLEX_SKIN_VERSION).zip
	# Download skin if required by configuration
	RASPLEX_EXTRA_DOWNLOADS = \
		$(RASPLEX_SKIN_SITE)/$(RASPLEX_SKIN_NAME)/$(RASPLEX_SKIN_FILE)
endif

# Skin configuration for Plex Black Edition
ifdef BR2_PACKAGE_RASPLEX_SKIN_PLEX_BLACK_EDITION
	RASPLEX_SKIN_NAME = skin.plex_black_editionHT
	RASPLEX_SKIN_VERSION = v16.11.24
	# URL information stored in /storage/.plexht/userdata/Database/Addons15.db
	RASPLEX_SKIN_SITE = https://addons.openpht.tv/openpht-1.6
	RASPLEX_SKIN_FILE = HQlrwa
	# Download skin if required by configuration
	RASPLEX_EXTRA_DOWNLOADS = https://goo.gl/$(RASPLEX_SKIN_FILE)
endif

define RASPLEX_BUILD_SKIN_CMD
	########## Apply Recalplex customization ############
	$(if $(BR2_PACKAGE_RECALPLEX), \
		# Unzip rasplex skin for customization
		mkdir -p $(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/; \
		unzip -q -o $(DL_DIR)/$(RASPLEX_SKIN_FILE) -d $(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/; \
		# Customize AeonNox theme
		$(if $(BR2_PACKAGE_RASPLEX_SKIN_AEONNOX), \
			cp -r $(RASPLEX_PKGDIR)recalplex/addons/$(RASPLEX_SKIN_NAME)/* \
				$(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/$(RASPLEX_SKIN_NAME)/;
		)
		# Customize Plex Black Edition theme
		$(if $(BR2_PACKAGE_RASPLEX_SKIN_PLEX_BLACK_EDITION), \
			touch $(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/$(RASPLEX_SKIN_NAME)/720p/Backgrounds.xml_
			awk '/<!-- positioning grid -->/ { while(getline line<"$(RASPLEX_PKGDIR)recalplex/addons/$(RASPLEX_SKIN_NAME)/Backgrounds.xml.insert"){print line} }1' $(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/$(RASPLEX_SKIN_NAME)/720p/Backgrounds.xml > "$(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/$(RASPLEX_SKIN_NAME)/720p/Backgrounds.xml_"
			rm $(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/$(RASPLEX_SKIN_NAME)/720p/Backgrounds.xml
			mv $(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/$(RASPLEX_SKIN_NAME)/720p/Backgrounds.xml_ $(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/$(RASPLEX_SKIN_NAME)/720p/Backgrounds.xml
			touch $(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/$(RASPLEX_SKIN_NAME)/720p/IncludesHomeMenu.xml_
			awk '/<item id="121">/ { while(getline line<"$(RASPLEX_PKGDIR)recalplex/addons/$(RASPLEX_SKIN_NAME)/IncludesHomeMenu.xml.insert"){print line} }1' $(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/$(RASPLEX_SKIN_NAME)/720p/IncludesHomeMenu.xml > "$(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/$(RASPLEX_SKIN_NAME)/720p/IncludesHomeMenu.xml_"
			rm $(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/$(RASPLEX_SKIN_NAME)/720p/IncludesHomeMenu.xml
			mv $(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/$(RASPLEX_SKIN_NAME)/720p/IncludesHomeMenu.xml_ $(RASPLEX_TAR_BUILD)/plexdata/.plexht/addons/$(RASPLEX_SKIN_NAME)/720p/IncludesHomeMenu.xml
		)
		# Copy customized rasplex skin settings 
		mkdir -p $(RASPLEX_TAR_BUILD)/plexdata/.plexht/userdata/; \
		cp -r $(RASPLEX_PKGDIR)recalplex/userdata/$(RASPLEX_SKIN_NAME)/* \
			$(RASPLEX_TAR_BUILD)/plexdata/.plexht/userdata/; \
		# Copy recalplex directory with autoswitch scripts and slideshow images
		mkdir -p $(RASPLEX_TAR_BUILD)/plexdata/.recalplex/slideshow; \
		cp $(RASPLEX_PKGDIR)recalplex/* $(RASPLEX_TAR_BUILD)/plexdata/.recalplex/ 2>/dev/null || : ; \
		cp $(RASPLEX_PKGDIR)recalplex/slideshow/* $(RASPLEX_TAR_BUILD)/plexdata/.recalplex/slideshow/ 2>/dev/null || : ; \
		# Customize noobs partition setup
		cat $(RASPLEX_PKGDIR)noobs/partition_setup.txt >> $(RASPLEX_TRG_BUILD)/partition_setup.sh; \
	)
endef

define RASPLEX_BUILD_CMDS
	$(call RASPLEX_BUILD_POWER_CMD)
	$(call RASPLEX_BUILD_SKIN_CMD)
endef

#####################################################################
# 	POST_BUILD : Compress partitions directories into tar.xz
#####################################################################
define RASPLEX_POST_BUILD_CMDS
	########## Create partition tar files ##########
	$(foreach p, $(RASPLEX_PARTITIONS), \
		pushd $(RASPLEX_TAR_BUILD)/$(p) > /dev/null; \
		f=$(RASPLEX_TRG_BUILD)/$(p).tar; \
		tar uf $$f . --owner=0 --group=0; xz -v $$f; \
		popd > /dev/null; \
	)
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
	rm -rf $(RASPLEX_TRG_INSTALL); \
	cp -r $(RASPLEX_SRC_INSTALL) $(RASPLEX_TRG_INSTALL);
endef

$(eval $(generic-package))