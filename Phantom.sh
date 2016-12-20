#!/bin/sh

#
 # Copyright © 2016, Harshit Jain <harshitjain6751@gmail.com>
 #
 # Custom build script
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
 # Use it I also Have kanged it from somewhere
#
restore='\033[0m'
KERNEL_DIR=$PWD
KERNEL="zImage"
ANYKERNEL_DIR="$KERNEL_DIR/arch/arm/boot/AnyKernel2"
REPACK_DIR="$ANYKERNEL_DIR"
ZIP_MOVE="$KERNEL_DIR"
KERN_IMG=$KERNEL_DIR/arch/arm/boot/zImage
DTBTOOL=$KERNEL_DIR/scripts/dtbToolCM
BASE_VER="PhAnToM"
VER="-R3-$(date +"%Y-%m-%d"-%H%M)-"
Phantom_VER="$BASE_VER$VER$TC"
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
green='\033[01;32m'
red='\033[0;31m'
blink_red='\033[05;31m'
nocol='\033[0m'
TC="Linaro"
# Modify the following variable if you want to build
export CROSS_COMPILE="/home/harshit/android/kernel/toolchain/gcc-linaro-6.2.1-2016.11-x86_64_arm-eabi/bin/arm-eabi-"
export ARCH=arm
#export SUBARCH=arm
export KBUILD_BUILD_USER="Halogen"
export KBUILD_BUILD_HOST="DeatH-MachinE"
STRIP="/home/harshit/android/kernel/toolchain/gcc-linaro-6.2.1-2016.11-x86_64_arm-eabi/bin/arm-eabi-strip"
MODULES_DIR=$KERNEL_DIR/arch/arm/boot/AnyKernel2/modules
echo -e "$green***********************************************"
echo "  Brace Yourselves You are building one of the best Msm8916 kernel ;)   "
echo -e "***********************************************$nocol"

echo -e "${green}"
echo "--------------------------------------------------------"
echo "    Wellcome !!!   Initiatig To Compile $Phantom_VER    "
echo "--------------------------------------------------------"

compile_phantom ()
{
echo -e "$yellow***********************************************"
echo "          Compiling PhAnToM kernel          "
echo -e "***********************************************$nocol"
rm -f $KERN_IMG
echo -e "$red***********************************************"
echo "          Cleaning Up Before Compile          "
echo -e "***********************************************$nocol"
make clean && make mrproper
echo -e "$yellow***********************************************"
echo "          Initialising DEFCONFIG        "
echo -e "***********************************************$nocol"
make cyanogenmod_wt86518-32_defconfig -j12
echo -e "$yellow***********************************************"
echo "          Cooking PhAnToM Kernel         "
echo -e "***********************************************$nocol"
make zImage -j12
echo -e "$yellow***********************************************"
echo "          GENERATING DEVICE TREE BLOBS          "
echo -e "***********************************************$nocol"
make dtbs -j12
echo -e "$yellow***********************************************"
echo "         Modules & Stuffs        "
echo -e "***********************************************$nocol"
make modules -j12
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm/boot/AnyKernel2/dtb -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
cp -vr $KERN_IMG $REPACK_DIR/zImage
strip_modules
}

strip_modules ()
{
echo "Copying modules"
rm $MODULES_DIR/*
find . -name '*.ko' -exec cp {} $MODULES_DIR/ \;
cd $MODULES_DIR
echo "Stripping modules for size"
$STRIP --strip-unneeded *.ko
cd $KERNEL_DIR
make_zip
}

make_zip ()
{
		cd $REPACK_DIR
                zip -r `echo $Phantom_VER$TC`.zip *
		mv  `echo $Phantom_VER$TC`.zip $ZIP_MOVE
cd $KERNEL_DIR
}
case $1 in
clean)
make ARCH=arm -j8 clean mrproper
rm -rf $KERNEL_DIR/arch/arm/boot/dt.img
;;
dt)
make cyanogenmod_wt86518-32_defconfig -j12
make dtbs -j12
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
;;
*)
compile_phantom
;;
esac
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
