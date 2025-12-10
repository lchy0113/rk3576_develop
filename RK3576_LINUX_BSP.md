RK3576_UBUNTU
====

RK3576 SoC Platform에 우분투 운영체제를 동작 시키는 업무에 관한 문서

> Rockchip 공식 입장은 Ubuntu 는 지원하지 않음


Ubuntu 관련 source (아래 Link에서 다운)
http://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04.5-base-arm64.tar.gz 

관련 설명 자료
 RK3576 Linux SDK
  - 현재 Version은 Linux 6.1 Beta version. 

<br/>
<br/>
<br/>
<br/>
<hr>

# Rockchip Linux BSP Directory Structure Guide
> Based on : rk3576_linux6.1_beta_v0.1.0_20240420

📁 루트 디렉터리 구조

```bash
app  
buildroot   // lightweight RootFS
build.sh  -> device/rockchip/common/scripts/build.sh  
common    -> device/rockchip/common  
Copyright_Statement.md  
debian      // Full-featured ARM64 Debian/Ubuntu RootFS
device  
docs  
external  
kernel -> kernel-6.1  
kernel-6.1    // linux kernel + driver
Makefile -> device/rockchip/common/Makefile  
output  
prebuilts  
README.md -> device/rockchip/common/README.md  
repo  
rkbin        // Proprietary firmware blobs
rkflash.sh -> device/rockchip/common/scripts/rkflash.sh  
rockdev -> output/firmware  // Final firmware images
tools  
u-boot       // bootloader
yocto        // Industrial Linux distribution
```

<br/>
<br/>
<br/>
<hr>

## 1. Overview

Rockchip Linux BSP는 부트로더(U-Boot), 커널(Linux Kernel),  
RootFS(Buildroot/Debian/Yocto), Firmware 패킹 시스템으로 구성.  
  
Android BSP와 다르게 Rockchip Linux BSP는  
심볼릭 링크를 사용하여 루트 디렉터리에서 빌드 스크립트와 핵심 파일을 바로 사용할 수 있게 되어 있음.  

<br/>
<br/>
<br/>
<hr> 

## 2. Direcotry 상세 설명

### 2.1 build.sh

경로:
```
build.sh -> device/rockchip/common/scripts/build.sh
```

Rockchip BSP의 메인 빌드 스크립트로 전체 빌드 프로세스를 제어.  
 - U-Boot 빌드
 - Kernel 빌드
 - RootFS(Buildroot/Debian/Yocto) 빌드
 - Firmware 패킹(update.img) 생성  

사용 예:
```bash
./build.sh lunch
./build.sh kernel
./build.sh debian
./build.sh
```

### 2.2 common → device/rockchip/common

빌드와 관련된 핵심 스크립트가 모여 있는 Rockchip BSP의 핵심 디렉터리.  
포함 내용:  
 - build-helper.sh
 - build-hooks/*
 - mk-image.sh
 - mk-rootfs.sh
 - 펌웨어 패킹 스크립트(rkImageMaker 등)

BSP 동작 로직의 중앙 제어부. 

### 2.3 Makefile (심볼릭링크)
실제 파일: device/rockchip/common/Makefile  
 - build.sh가 include하는 빌드 규칙 정의
 - kernel, u-boot, rootfs, firmware 타깃 제어
 - output/rockdev 구조 정의

### 2.4 kernel & kernel-6.1
 - kernel → kernel-6.1 심볼릭 링크
 - 실제 커널 소스 트리: kernel-6.1
  
포함:

 - Rockchip SoC 드라이버
 - ISP/VOP/NPU/GPU 지원
 - DTS/DTSI 파일(rk3576.dtsi 등)

빌드:
```
./build.sh kernel
```

### 2.5 u-boot
Rockchip 부트로더 소스.  
  
출력물 예:  
```
MiniLoaderAll.bin
uboot.img
trust.img
```
  
BSP 부팅 체인의 첫 단계 구성요소.  
  
### 2.6 buildroot
Buildroot 기반의 경량 RootFS 생성 시스템.  
  
특징:  
 - busybox 기반 최소 리눅스
 - 빠른 부팅 시간
 - 가벼운 시스템 구성

빌드:
```
./build.sh buildroot
```

### 2.7 debian
Debian/Ubuntu 기반 RootFS 생성 스크립트.  
  
포함:
 - mk-base-debian.sh
 - debootstrap 기반 rootfs build
 - QEMU + binfmt 필요
 - Ubuntu 가져오기 스크립트 포함
  
빌드:  
```
./build.sh debian
```
  
ARM64 rootfs를 생성하는 데 사용됨.  

### 2.8 yocto
Yocto Project 기반 리눅스 빌드 환경.  
산업용·자동차용 이미지 생성을 목표.  
  
빌드 예:
```
source yocto/envsetup.sh
bitbake core-image-minimal
```

### 2.9 external
외부 라이브러리 + Rockchip 사용자 공간 라이브러리.  
  
포함 가능:
 - Mali GPU userspace
 - Rockchip VPU codecs
 - GStreamer plugins (rockchip edition)
 - ISP AIQ 라이브러리(rkaiq)
 - rkmedia 등 미들웨어

Android BSP의 external/ + vendor/에 해당.

### 2.10 prebuilts
Rockchip BSP의 toolchain 및 유틸리티.  
  
예:
```
prebuilts/gcc/linux-x86/aarch64/gcc-arm-10.3-2021.07/
prebuilts/mkimage/
prebuilts/tools/
```

### 2.11 rkbin
Rockchip 제공 바이너리 블롭(proprietary binaries).  
  
포함:
 - BL31 (ARM Trusted Firmware)
 - BL32 (OP-TEE)
 - DDR init firmware
 - firmware blobs
  
U-Boot 및 부팅 체인의 필수 구성요소.  

### 2.12 tools
Rockchip 이미지 패킹 및 유틸리티 모음.  

예:
 - rkdeveloptool
 - upgrade_tool
 - img_unpack
 - resource_packer
 - rkImageMaker

### 2.13 rockdev → output/firmware (심볼릭 링크)
최종 생성된 펌웨어 이미지가 저장되는 폴더.  

예시:
```
boot.img
rootfs.img
kernel.img
uboot.img
update.img
parameter.txt
```

Android BSP의 out/target/product/<device>/ 역할과 유사.


### 2.14 output
중간 빌드 산출물 및 로그 저장 위치.  

예:
```
output/
  sessions/       # 빌드 로그
  kernel/
  uboot/
  buildroot/
  debian/
  firmware/ -> rockdev
```

빌드 실패 시 가장 먼저 확인해야 하는 폴더.


<br/>
<br/>
<br/>
<br/>
<hr>

# build rootfs with buildroot


```
lchy0113@7a6a8fd63289:~/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420$ ./build.sh lunch 

############### Rockchip Linux SDK ###############

Manifest: rk3576_linux6.1_beta_v0.1.0_20240420.xml

Log colors: message notice warning error fatal

Log saved at /home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/sessions/2025-12-10_09-05-33
Pick a defconfig:

1. rockchip_defconfig
2. rockchip_rk3576_evb1_v10_defconfig
3. rockchip_rk3576_industry_evb_v10_defconfig
4. rockchip_rk3576_iotest_v10_defconfig
5. rockchip_rk3576_test1_v10_defconfig
6. rockchip_rk3576_test2_v10_defconfig
7. rockchip_rk3576_vehicle_evb_v10_defconfig
Which would you like? [1]: 2
Switching to defconfig: /home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/device/rockchip/.chip/rockchip_rk3576_evb1_v10_defconfig
mkdir -p /home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf/lxdialog
make CC="gcc" HOSTCC="gcc" \
    obj=/home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf -C /home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/device/rockchip/common/kconfig -f Makefile.br conf
make[1]: Entering directory '/home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/device/rockchip/common/kconfig'
gcc -I/usr/include/ncursesw -DCURSES_LOC="<curses.h>"  -DNCURSES_WIDECHAR=1 -DLOCALE  -I/home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf -DCONFIG_=\"\"  -MM *.c > /home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf/.depend 2>/dev/null || :
gcc -I/usr/include/ncursesw -DCURSES_LOC="<curses.h>"  -DNCURSES_WIDECHAR=1 -DLOCALE  -I/home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf -DCONFIG_=\"\"   -c conf.c -o /home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf/conf.o
gcc -I/usr/include/ncursesw -DCURSES_LOC="<curses.h>"  -DNCURSES_WIDECHAR=1 -DLOCALE  -I/home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf -DCONFIG_=\"\"  -I. -c /home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf/zconf.tab.c -o /home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf/zconf.tab.o
gcc -I/usr/include/ncursesw -DCURSES_LOC="<curses.h>"  -DNCURSES_WIDECHAR=1 -DLOCALE  -I/home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf -DCONFIG_=\"\"   /home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf/conf.o /home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf/zconf.tab.o  -o /home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf/conf
rm /home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/kconf/zconf.tab.c
make[1]: Leaving directory '/home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/device/rockchip/common/kconfig'
#
# configuration written to /home/lchy0113/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420/output/.config
#

(...)

lchy0113@7a6a8fd63289:~/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420$ ./build.sh all
```



