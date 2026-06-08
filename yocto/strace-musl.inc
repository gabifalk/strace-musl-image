MACHINE = "qemux86-64"
TCLIBC = "musl"

IMAGE_FEATURES:append = " tools-sdk dev-pkgs"
IMAGE_INSTALL:append = " packagegroup-core-buildessential coreutils gawk sed grep findutils autoconf automake libtool m4 pkgconfig git make file bash perl xz"

IMAGE_FSTYPES = "tar.bz2"
IMAGE_CLASSES:remove = "qemuboot"
PREFERRED_PROVIDER_virtual/kernel = "linux-dummy"

INHERIT += "own-mirrors rm_work"
SOURCE_MIRROR_URL = "http://downloads.yoctoproject.org/mirror/sources/"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
