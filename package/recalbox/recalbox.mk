################################################################################
#
# recalbox
#
################################################################################
RECALBOX_DEPENDENCIES = noobs
RECALBOX_VERSION = 6.1.1-Dragonblaze
RECALBOX_SOURCE = boot.tar.xz?source=install
RECALBOX_SITE = https://recalbox-releases.s3.nl-ams.scw.cloud/stable/v2/upgrade/$(BR2_ARCH)
RECALBOX_EXTRA_DOWNLOADS = $(RECALBOX_SITE)/root.tar.xz?source=install

RECALBOX_TRG_BUILD = $(@D)/os/$(RECALBOX_NAME)
RECALBOX_TAR_BUILD = $(RECALBOX_TRG_BUILD).dsk

#####################################################################
# 	EXTRACT : Extract source version files
#####################################################################
define RECALBOX_EXTRACT_CMDS
	set -e
	rm -rf $(RECALBOX_TRG_BUILD)
	mkdir -p $(RECALBOX_TRG_BUILD)
	cp "$(DL_DIR)/boot.tar.xz?source=install" "$(RECALBOX_TRG_BUILD)/boot.tar.xz"
	cp "$(DL_DIR)/root.tar.xz?source=install" "$(RECALBOX_TRG_BUILD)/root.tar.xz"
	cd $(RECALBOX_TRG_BUILD) > /dev/null;	\
		unxz -v $(RECALBOX_TRG_BUILD)/root.tar.xz
endef

#####################################################################
# 	CONFIGURE : Create noobs os directory for selected rpi
# 	$(@D)/os/recalbox (Noobs configuration)
#####################################################################
define RECALBOX_CONFIGURE_CMDS
	set -e
	cp -r $(RECALBOX_PKGDIR)noobs/rpi/* $(RECALBOX_TRG_BUILD)/
	cp -r $(RECALBOX_PKGDIR)noobs/$(BR2_ARCH)/* $(RECALBOX_TRG_BUILD)/
endef

#####################################################################
# 	BUILD : Customize partition directories
# 	$(@D)/os/recalbox.dsk/* (Partitions directories with new files)
#####################################################################
define RECALBOX_BUILD_POWERSWITCH_REMOTEPI_2013
	set -e
	rm -rf $(RECALBOX_TAR_BUILD)/root
	mkdir -p $(RECALBOX_TAR_BUILD)/root
	cd $(RECALBOX_TAR_BUILD)/root; \
		tar xvf $(RECALBOX_TRG_BUILD)/root.tar ./recalbox/share_init/system/recalbox.conf
	$(SED) "s|^.*\(system.power.switch\)\s*=\s*\(REMOTEPIBOARD_20[0-1]3\s*.*\)$$|\1=\2|g" \
		$(RECALBOX_TAR_BUILD)/root/recalbox/share_init/system/recalbox.conf
endef

define RECALBOX_BUILD_POWERSWITCH_REMOTEPI_2015
	set -e
	rm -rf $(RECALBOX_TAR_BUILD)/root
	mkdir -p $(RECALBOX_TAR_BUILD)/root
	cd $(RECALBOX_TAR_BUILD)/root; \
		tar xvf $(RECALBOX_TRG_BUILD)/root.tar ./recalbox/share_init/system/recalbox.conf
	$(SED) "s|^.*\(system.power.switch\)\s*=\s*\(REMOTEPIBOARD_20[0-1]5\s*.*\)$$|\1=\2|g" \
		$(RECALBOX_TAR_BUILD)/root/recalbox/share_init/system/recalbox.conf
endef

define RECALBOX_BUILD_RECALPLEX
	set -e	
	rm -rf $(RECALBOX_TAR_BUILD)/share
	mkdir -p $(RECALBOX_TAR_BUILD)/share
	cp -r $(RECALBOX_PKGDIR)partitions/share/* $(RECALBOX_TAR_BUILD)/share/
	cat $(RECALBOX_PKGDIR)noobs/partition_setup.txt >> $(RECALBOX_TRG_BUILD)/partition_setup.sh
	$(SED) "s|^\([[:blank:]]*\"empty_fs\"\)[[:blank:]]*:[[:blank:]]*\(true\).*|\1: false|g" \
		$(RECALBOX_TRG_BUILD)/partitions.json
endef

define RECALBOX_BUILD_CMDS
	set -e
	$(if $(BR2_ARCH_POWERSWITCH_REMOTEPI_2013), \
		$(call RECALBOX_BUILD_POWERSWITCH_REMOTEPI_2013))
	$(if $(BR2_ARCH_POWERSWITCH_REMOTEPI_2015), \
		$(call RECALBOX_BUILD_POWERSWITCH_REMOTEPI_2015))
	$(if $(BR2_PACKAGE_RECALPLEX), \
		$(call RECALBOX_BUILD_RECALPLEX))
	cd $(RECALBOX_TAR_BUILD)/root; \
		tar uf $(RECALBOX_TRG_BUILD)/root.tar . --owner=0 --group=0; \
		xz -v $(RECALBOX_TRG_BUILD)/root.tar
	cd $(RECALBOX_TAR_BUILD)/share; \
		tar uf $(RECALBOX_TRG_BUILD)/share.tar . --owner=0 --group=0; \
		xz -v $(RECALBOX_TRG_BUILD)/share.tar
endef

#####################################################################
# 	INSTALL : Copy the content of the $(RECALBOX_TRG_BUILD)
#	          to the target/os/recalbox
#####################################################################
RECALBOX_TRG_INSTALL = $(TARGET_DIR)/os/$(RECALBOX_NAME)

define RECALBOX_INSTALL_TARGET_CMDS
	set -e
	rm -rf $(RECALBOX_TRG_INSTALL)
	cp -r $(RECALBOX_TRG_BUILD) $(RECALBOX_TRG_INSTALL) 
endef

$(eval $(generic-package))