#!/bin/sh

# This file is part of BOINC.
# https://boinc.berkeley.edu
# Copyright (C) 2025 University of California
#
# BOINC is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License
# as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# BOINC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with BOINC.  If not, see <http://www.gnu.org/licenses/>.

set -e

PLATFORM_NAME="osx"

if [ ! -d "$PLATFORM_NAME" ]; then
    echo "start this script in the source root directory"
    exit 1
fi

BUILD_DIR="$PWD/3rdParty/$PLATFORM_NAME"
VCPKG_ROOT="$BUILD_DIR/vcpkg"
VCPKG_PORTS="$PWD/3rdParty/vcpkg_ports"

$PLATFORM_NAME/bootstrap_vcpkg_cmake.sh

TRIPLET="$1"
case "$TRIPLET" in
    "x64-osx"|"arm64-osx")
        echo "\033[0;35m building $TRIPLET ... \033[0m"

        BUILD_TRIPLET=build-$TRIPLET
        cmake lib -B $BUILD_TRIPLET -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake -DVCPKG_MANIFEST_DIR=3rdParty/vcpkg_ports/configs/libs/ -DVCPKG_INSTALLED_DIR=$VCPKG_ROOT/installed/ -DVCPKG_OVERLAY_PORTS=$VCPKG_PORTS/ports -DVCPKG_OVERLAY_TRIPLETS=$VCPKG_PORTS/triplets/ci -DVCPKG_TARGET_TRIPLET=$TRIPLET -DVCPKG_INSTALL_OPTIONS=--clean-after-build
        cmake --build $BUILD_TRIPLET

        echo "\033[1;32m $TRIPLET done \033[0m"
        ;;
    *)
        echo "unknown triplet $TRIPLET"
        exit 1
        ;;
esac
