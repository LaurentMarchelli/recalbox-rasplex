################################################################################
#
# skeleton
#
################################################################################

# Keepig sekeleton as minimal definition to avoid modification of pkg-generic.mk and Makefile.in
BR2_PACKAGE_SKELETON=y
SKELETON_SOURCE =
SKELETON_ADD_TOOLCHAIN_DEPENDENCY = NO

$(eval $(generic-package))
