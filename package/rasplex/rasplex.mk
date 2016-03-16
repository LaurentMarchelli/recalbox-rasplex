################################################################################
#
# rasplex
#
################################################################################

RASPLEX_VERSION = 1.0.3
RASPLEX_SOURCE = RASPLEX_$(RASPLEX_VERSION).zip
RASPLEX_SITE = https://downloads.raspberrypi.org/RASPLEX/images/RASPLEX-2016-02-09
#RASPLEX_SITE = https://downloads.raspberrypi.org/RASPLEX_latest
RASPLEX_LICENSE = GPL2
RASPLEX_LICENSE_FILES = COPYING

define RASPLEX_EXTRACT_CMDS
	unzip -q -o $(DL_DIR)/$(RASPLEX_SOURCE) -d $(@D)/rasplex
endef

define RASPLEX_BUILD_CMDS
	echo "build"
endef

$(eval $(generic-package))