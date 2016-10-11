################################################################################
#
# recalboxos
#
################################################################################

RECALBOXOS_RELEASE = 4.0.0-beta5
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

ifeq ($(BR2_PACKAGE_NOOBS),y)
	RECALBOXOS_DEPENDENCIES=noobs
	RECALBOXOS_INSTALL_NOOBS=
else
	RECALBOXOS_DEPENDENCIES=
	RECALBOXOS_INSTALL_NOOBS=NOOBS_INSTALL_TARGET_CMDS
endif

RECALBOXOS_SRC_BUILD=$(@D)/os/$(RECALBOXOS_NAME)-$(BR2_ARCH)
RECALBOXOS_TRG_BUILD=$(@D)/os/$(RECALBOXOS_NAME)

define RECALBOXOS_EXTRACT_CMDS
	@unzip -q -o $(DL_DIR)/$(RECALBOXOS_SOURCE) -d $(@D); \
	if test -e $(DL_DIR)/boot.tar.xz; then \
		mv $(DL_DIR)/boot.tar.xz $(RECALBOXOS_SRC_BUILD)/; \
	fi; \
	if test -e $(DL_DIR)/root.tar.xz; then \
		mv $(DL_DIR)/root.tar.xz $(RECALBOXOS_SRC_BUILD)/; \
	fi;
endef

define RECALBOXOS_BUILD_CMDS
	@if test -d $(RECALBOXOS_TRG_BUILD); then \
		rm -rf $(RECALBOXOS_TRG_BUILD); \
	fi; \
	mkdir -p $(RECALBOXOS_TRG_BUILD); \
	cp -r $(RECALBOXOS_SRC_BUILD)/* $(RECALBOXOS_TRG_BUILD)/; \
	mv $(RECALBOXOS_TRG_BUILD)/$(RECALBOXOS_NAME)-$(BR2_ARCH).png \
		$(RECALBOXOS_TRG_BUILD)/$(RECALBOXOS_NAME).png; \
	$(SED) "s|^\(\s*\)\"name\": \"$(RECALBOXOS_NAME)-$(BR2_ARCH)\",.*|\1\"name\": \"$(RECALBOXOS_NAME)\",|g" \
		$(RECALBOXOS_TRG_BUILD)/os.json
endef

RECALBOXOS_SRC_INSTALL=$(RECALBOXOS_TRG_BUILD)
RECALBOXOS_TRG_INSTALL=$(TARGET_DIR)/os/$(RECALBOXOS_NAME)

define RECALBOXOS_INSTALL_TARGET_CMDS
	$(call $(RECALBOXOS_INSTALL_NOOBS))
	@if test -d $(RECALBOXOS_TRG_INSTALL); then \
		rm -rf $(RECALBOXOS_TRG_INSTALL); \
	fi; \
	cp -r $(RECALBOXOS_SRC_INSTALL) $(RECALBOXOS_TRG_INSTALL) 
endef

$(eval $(generic-package))
