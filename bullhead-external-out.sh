#!/bin/bash
#
# Copyright � 2015-2016, Akhil Narang "akhilnarang" <akhilnarang.1999@gmail.com>
# Build Script For ThugLife Kernel
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it
#

export EXT_OUT_DIR="/run/media/akhil/akhil-mint/out-thug/bullhead"
export DEVICE="bullhead";
export ARCH="arm64"
export IMAGE="${EXT_OUT_DIR}/arch/$ARCH/boot/Image.gz-dtb"
export ANYKERNEL=$THUGDIR/$DEVICE/anykernel
export DEFCONFIG="thug_defconfig";
export ZIPS_DIR="$THUGDIR/files/$DEVICE"
export THUGVERSION="$(grep "THUGVERSION = " ${THUGDIR}/bullhead/Makefile | awk '{print $3}')";
export ZIPNAME="thuglife-bullhead-${THUGVERSION}-$(date +%Y%m%d-%H%M).zip"
export FINAL_ZIP="$ZIPS_DIR/$ZIPNAME"
export MAKE_ARGS="-j16 O=${EXT_OUT_DIR}"
if [ "$1" == "sm" ];
then
export CROSS_COMPILE="${THUGDIR}/${DEVICE}-toolchain/bin/aarch64-"
else
export CROSS_COMPILE="${THUGDIR}/${DEVICE}-toolchain/bin/aarch64-linux-android-"
fi

if [ ! -d "$ZIPS_DIR" ];
then
mkdir -p $ZIPS_DIR
fi

cd $THUGDIR/$DEVICE

rm -f $IMAGE

make ${DEFCONFIG} O=${EXT_OUT_DIR}
figlet ThugLife
START=$(date +"%s")
make ${MAKE_ARGS}
END=$(date +"%s")
DIFF=$(($END - $START))
echo -e "Build took $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.";

if [ ! -f "$IMAGE" ];
then
echo -e "Kernel Compilation Failed!";
echo -e "Fix The Errors!";
else
echo -e "Build Succesfull Enjoy Living the ThugLife!"

cp -v $IMAGE $ANYKERNEL/kernel/zImage
cd $ANYKERNEL
zip -r9 $FINAL_ZIP *;
cd ..
if [ -f "$FINAL_ZIP" ];
then
echo -e "$ZIPNAME can be found at $FINAL_ZIP";
else
echo -e "Zip Creation Failed =(";
fi # $FINAL_ZIP found
fi # no $IMAGE found

