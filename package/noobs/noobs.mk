################################################################################
#
# noobs
#
################################################################################

NOOBS_VERSION = v2_0_0
NOOBS_SOURCE = NOOBS_$(NOOBS_VERSION).zip
NOOBS_SITE = https://downloads.raspberrypi.org/NOOBS/images/NOOBS-2016-10-05
#NOOBS_SITE = https://downloads.raspberrypi.org/NOOBS_latest
NOOBS_LICENSE = GPL2
NOOBS_LICENSE_FILES = COPYING

define NOOBS_EXTRACT_CMDS
	@unzip -q -o $(DL_DIR)/$(NOOBS_SOURCE) -d $(@D)
endef

define NOOBS_BUILD_CMDS
endef

define NOOBS_INSTALL_TARGET_CMDS
	@for f in `ls $(TARGET_DIR)`; do rm -r $(TARGET_DIR)/$$f; done; \
	for f in `ls $(@D)`; do if [ "$$f" != "os" ]; then cp -rf $(@D)/$$f $(TARGET_DIR); fi; done; \
	mkdir -p $(TARGET_DIR)/os;
endef

$(eval $(generic-package))