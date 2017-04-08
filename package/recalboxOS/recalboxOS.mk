################################################################################
#
# recalboxos
#
################################################################################
RECALBOXOS_RELEASE = 4.0.1
RECALBOXOS_SOURCE = $(RECALBOXOS_NAME)-$(RECALBOXOS_RELEASE).zip
RECALBOXOS_SITE = https://github.com/recalbox/recalbox-os/releases/download/$(RECALBOXOS_RELEASE)

ifeq ($(BR2_PACKAGE_RECALBOXOS_UNSTABLE),y)
	RECALBOXOS_VERSION = 4.0-unstable
	RECALBOXOS_EXTRA_DOWNLOADS = \
		http://archive.recalbox.com/4/$(BR2_ARCH)/unstable/last/boot.tar.xz \
		http://archive.recalbox.com/4/$(BR2_ARCH)/unstable/last/root.tar.xz
else ifeq ($(BR2_PACKAGE_RECALBOXOS_NEXT),y)
	RECALBOXOS_VERSION = 4.1-unstable
	RECALBOXOS_EXTRA_DOWNLOADS = \
		http://archive.recalbox.com/4.1/$(BR2_ARCH)/unstable/last/boot.tar.xz \
		http://archive.recalbox.com/4.1/$(BR2_ARCH)/unstable/last/root.tar.xz
else
	RECALBOXOS_VERSION = $(RECALBOXOS_RELEASE)
endif

#####################################################################
# 	EXTRACT : Extract base version and apply needed updates
#####################################################################
RECALBOXOS_SRC_BUILD = $(@D)/os/$(RECALBOXOS_NAME)-$(BR2_ARCH)

define RECALBOXOS_EXTRACT_CMDS
	########## Extract base version ($(RECALBOXOS_RELEASE)) ##########
	unzip -q -o $(DL_DIR)/$(RECALBOXOS_SOURCE) -d $(@D);
	########## Apply version updates (boot & root) ##########
	$(if $(RECALBOXOS_EXTRA_DOWNLOADS),\
		mv $(DL_DIR)/boot.tar.xz $(RECALBOXOS_SRC_BUILD)/; \
		mv $(DL_DIR)/root.tar.xz $(RECALBOXOS_SRC_BUILD)/; \
	)
endef

#####################################################################
# 	CONFIGURE : Create noobs os directory for selected rpi
# 	$(@D)/os/rasplex (Noobs configuration)
#####################################################################
RECALBOXOS_TRG_BUILD = $(@D)/os/$(RECALBOXOS_NAME)

define RECALBOXOS_CONFIGURE_CMDS
	########## Create os/$(RECALBOXOS_NAME) for $(BR2_ARCH) ##########
	rm -rf $(RECALBOXOS_TRG_BUILD); \
	mkdir -p $(RECALBOXOS_TRG_BUILD); \
	cp -r $(RECALBOXOS_SRC_BUILD)/* $(RECALBOXOS_TRG_BUILD)/; \
	mv $(RECALBOXOS_TRG_BUILD)/$(RECALBOXOS_NAME)-$(BR2_ARCH).png \
		$(RECALBOXOS_TRG_BUILD)/$(RECALBOXOS_NAME).png; \
	$(SED) "s|^\(\s*\)\"name\": \"$(RECALBOXOS_NAME)-$(BR2_ARCH)\",.*|\1\"name\": \"$(RECALBOXOS_NAME)\",|g" \
		$(RECALBOXOS_TRG_BUILD)/os.json;
endef

#####################################################################
# 	PRE_BUILD : Prepare partition directories
# 	$(@D)/os/rasplex.dsk/* (Partitions extracted)
#####################################################################
RECALBOXOS_TAR_BUILD = $(RECALBOXOS_TRG_BUILD).dsk
RECALBOXOS_PARTITIONS = root boot share

RECALBOXOS_PART_boot =

ifndef BR2_ARCH_POWERSWITCH_NONE
	RECALBOXOS_FILE_recalbox_conf = ./recalbox/share_init/system/recalbox.conf
	RECALBOXOS_PART_root += $(RECALBOXOS_FILE_recalbox_conf)
endif
ifdef BR2_PACKAGE_RECALPLEX
	RECALBOXOS_PART_share = .keep
endif

define RECALBOXOS_PRE_BUILD_CMDS
	########## Untar needed partitions for customization ##########
	rm -rf $(RECALBOXOS_TAR_BUILD); \
	$(foreach p, $(RECALBOXOS_PARTITIONS), \
		$(if $(RECALBOXOS_PART_$(p)), \
			mkdir -p $(RECALBOXOS_TAR_BUILD)/$(p); \
			pushd $(RECALBOXOS_TAR_BUILD)/$(p) > /dev/null; \
			unxz -v $(RECALBOXOS_TRG_BUILD)/$(p).tar.xz; \
			for f in $(RECALBOXOS_PART_$(p)); do \
				tar xvf $(RECALBOXOS_TRG_BUILD)/$(p).tar $$f; \
			done; \
			popd > /dev/null; \
		) \
	)
endef

#####################################################################
# 	BUILD : Customize partition directories
#####################################################################
define RECALBOXOS_BUILD_POWER_CMD
	########## Apply Powerswitch configuration ##########
	$(if $(BR2_ARCH_POWERSWITCH_REMOTEPI_2013), \
		$(SED) "s|^.*\(system.power.switch\)\s*=\s*\(REMOTEPIBOARD_20[0-1]3\s*.*\)$$|\1=\2|g" \
			$(RECALBOXOS_TAR_BUILD)/root/$(RECALBOXOS_FILE_recalbox_conf);\
	)
	$(if $(BR2_ARCH_POWERSWITCH_REMOTEPI_2015), \
		$(SED) "s|^.*\(system.power.switch\)\s*=\s*\(REMOTEPIBOARD_20[0-1]5\s*.*\)$$|\1=\2|g" \
			$(RECALBOXOS_TAR_BUILD)/root/$(RECALBOXOS_FILE_recalbox_conf);\
	)
endef

define RECALBOXOS_BUILD_RECALPLEX_CMD
	########## Apply Recalplex customization ############
	$(if $(BR2_PACKAGE_RECALPLEX), \
		cp -r $(RECALBOXOS_PKGDIR)partitions/share/* $(RECALBOXOS_TAR_BUILD)/share/; \
		cat $(RECALBOXOS_PKGDIR)noobs/partition_setup.txt >> $(RECALBOXOS_TRG_BUILD)/partition_setup.sh; \
		$(SED) "s|^\([[:blank:]]*\"empty_fs\"\)[[:blank:]]*:[[:blank:]]*\(true\).*|\1: false|g" \
			$(RECALBOXOS_TRG_BUILD)/partitions.json; \
	)
endef

define RECALBOXOS_BUILD_CMDS
	$(call RECALBOXOS_BUILD_POWER_CMD)
	$(call RECALBOXOS_BUILD_RECALPLEX_CMD)
endef

#####################################################################
# 	POST_BUILD : Update partitions tar files if needed
#####################################################################
define RECALBOXOS_POST_BUILD_CMDS
	########## Update partition tar files ##########
	$(foreach p, $(RECALBOXOS_PARTITIONS), \
		$(if $(RECALBOXOS_PART_$(p)), \
			pushd $(RECALBOXOS_TAR_BUILD)/$(p) > /dev/null; \
			f=$(RECALBOXOS_TRG_BUILD)/$(p).tar; \
			tar uf $$f . --owner=0 --group=0; xz -v $$f; \
			popd > /dev/null; \
		) \
	)
endef

RECALBOXOS_PRE_BUILD_HOOKS += RECALBOXOS_PRE_BUILD_CMDS
RECALBOXOS_POST_BUILD_HOOKS += RECALBOXOS_POST_BUILD_CMDS

#####################################################################
# 	INSTALL : Copy the content of the $(RECALBOXOS_TRG_BUILD)
#	          to the target/os/recalboxOS
#####################################################################
ifeq ($(BR2_PACKAGE_NOOBS),y)
	RECALBOXOS_DEPENDENCIES = noobs
	RECALBOXOS_INSTALL_NOOBS =
else
	RECALBOXOS_DEPENDENCIES =
	RECALBOXOS_INSTALL_NOOBS = NOOBS_INSTALL_TARGET_CMDS
endif

RECALBOXOS_SRC_INSTALL = $(RECALBOXOS_TRG_BUILD)
RECALBOXOS_TRG_INSTALL = $(TARGET_DIR)/os/$(RECALBOXOS_NAME)
define RECALBOXOS_INSTALL_TARGET_CMDS
	$(call $(RECALBOXOS_INSTALL_NOOBS))
	rm -rf $(RECALBOXOS_TRG_INSTALL); \
	cp -r $(RECALBOXOS_SRC_INSTALL) $(RECALBOXOS_TRG_INSTALL) 
endef

$(eval $(generic-package))