# AW-XM549 

**AW-XM549** : WIFI-BT5.3+Tri-radio Module 의 BT 기능을 구현.  

 - 구조 
| 구분                       | 역할                                    | 주요 제품                                     |
| -------------------------- | --------------------------------------- | --------------------------------------------- |
| **NXP Semiconductors**     | 칩셋 제조사 (Wi-Fi/Bluetooth/Thread용 SoC 공급) | **88W8987**, **IW416**, **IW612** 등  |
| **AzureWave Technologies** | 모듈 제조사 (칩셋 + RF 회로 + 안테나 + 인증 포함한 모듈화)  | **AW-XM549**, **AW-CM358**, **AW-CM256SM**, 등 |

**AW_XM549** 의 구성  
 - chipset : NXP **IW612**
   * Wi-Fi 6(2.4 GHz/5 GHz)
   * Bluetooth 5.3
   * Thread (IEEE 802.15.4)
 - 모듈화: AzureWave가 NXP IW612를 기반으로 **RF 보정, 안테나 매칭, 전원회로, 인증(CE, FCC, KC 등)**을 완료한 모듈 형태로 제공
 - 따라서 개발사는 NXP SDK(예: MCUXpresso SDK for IW612)를 기반으로 하면서도, HW 설계 및 RF 인증은 AzureWave 모듈을 그대로 사용하여 빠르게 통합할 수 있습니다.



<br/>
<br/>
<br/>
<br/>
<hr>

# ETC 

```
File Location : android_build\device\nxp\imx8m\evk_8mp\BoardConfig.mk

# -------@block_wifi-------

# NXP 8997 WIFI

BOARD_WLAN_DEVICE            := nxp

WPA_SUPPLICANT_VERSION       := VER_0_8_X

BOARD_WPA_SUPPLICANT_DRIVER  := NL80211

BOARD_HOSTAPD_DRIVER         := NL80211

BOARD_HOSTAPD_PRIVATE_LIB               := lib_driver_cmd_$(BOARD_WLAN_DEVICE)

BOARD_WPA_SUPPLICANT_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)

 

WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

# -------@block_bluetooth-------

# NXP 8997 BT

BOARD_HAVE_BLUETOOTH_NXP := true

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth

 
```
