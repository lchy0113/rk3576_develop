RK3576_UBUNTU
====

RK3576 SoC Platform에 우분투 운영체제를 동작 시키는 업무에 관한 문서

 - Rockchip 공식 입장은 Ubuntu 는 지원하지 않음


1. Ubuntu 관련 source (아래 Link에서 다운)
http://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04.5-base-arm64.tar.gz 

2. 관련 설명 자료
 RK3576 Linux SDK
  - 현재 Version은 Linux 6.1 Beta version. 


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

lchy0113@7a6a8fd63289:~/proj/rockchip/Linux/BSP/rk3576_linux6.1_beta_v0.1.0_20240420$ ./build.sh rootfs
```



