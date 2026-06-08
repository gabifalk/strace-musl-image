#!/bin/bash
# Build the strace musl rootfs with Yocto.
# On success leaves the rootfs tarball at $WORKDIR/rootfs.tar.bz2; otherwise fails.
# Honors env: WORKDIR, SSTATE_DIR, DL_DIR.
set -e

WORKDIR="${WORKDIR:-$PWD/yocto-build}"
BUILD_DIR="$WORKDIR/build"
SSTATE_DIR="${SSTATE_DIR:-$PWD/sstate-cache}"
DL_DIR="${DL_DIR:-$PWD/downloads}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

OE_CORE_BRANCH=wrynose
BITBAKE_BRANCH=2.18
META_YOCTO_BRANCH=wrynose

mkdir -p "$WORKDIR" "$SSTATE_DIR" "$DL_DIR"
git clone -b "$OE_CORE_BRANCH"     https://git.openembedded.org/openembedded-core "$WORKDIR/oe-core"
git clone -b "$BITBAKE_BRANCH"     https://git.openembedded.org/bitbake           "$WORKDIR/oe-core/bitbake"
git clone -b "$META_YOCTO_BRANCH"  https://git.yoctoproject.org/meta-yocto        "$WORKDIR/meta-yocto"

source "$WORKDIR/oe-core/oe-init-build-env" "$BUILD_DIR" >/dev/null

cat >> "$BUILD_DIR/conf/local.conf" <<EOF
require $REPO_DIR/yocto/strace-musl.inc
DL_DIR = "$DL_DIR"
SSTATE_DIR = "$SSTATE_DIR"
BB_HASHSERVE_DB_DIR = "$SSTATE_DIR"
EOF

bitbake core-image-minimal
tarballs=("$BUILD_DIR"/tmp/deploy/images/*/core-image-minimal-*.rootfs.tar.bz2)
cp "${tarballs[0]}" "$WORKDIR/rootfs.tar.bz2"
