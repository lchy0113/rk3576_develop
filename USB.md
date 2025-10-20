USB
=====

<br/>
<br/>
<br/>
<br/>
<hr>

# Linux USB Device Tree(DT) 설정

> USB 장치의 DT 속성 정리. 

<br/>
<br/>
<br/>
<hr>

## USB Controller Properties

> USB 컨트롤러 노드에서 사용되는 속성 

 - usb_drd0_dwc3

| 속성                           | 설명                                                                         |
| ---------------------------- | -------------------------------------------------------------------------- |
| **usb-role-switch**          | PD(전력 공급) 컨트롤러가 있는 Type-C 포트에서 사용. dr_mode="otg" 일 때 필수. OTG 역할 전환을 위한 장치. |
| **extcon**                   | OTG 전환 시 사용하는 외부 커넥터(USB Micro/Type-A 등).                                  |
| **snps,dis_u2_susphy_quirk** | USB 컨트롤러의 자동 suspend(절전) 기능 비활성화. 주로 USB 2.0 안정성 개선용.                      |
| **snps,usb2-lpm-disable**    | LPM(Low Power Mode) 비활성화. USB 2.0 only 구성 시 사용.                            |


<br/>
<br/>
<br/>
<hr>

## USB2 PHY Properties

> USB2 PHY 전원 및 GRF 설정 관련

 - usb_drd0_dwc3

| 속성                            | 설명                                                         |
| ----------------------------- | ---------------------------------------------------------- |
| **vbus-supply / phy-supply**  | 5V 전원 공급 제어용. OTG 모드는 vbus-supply, HOST 모드는 phy-supply 사용. |
| **rockchip,selphy-phystatus** | GRF USB 제어기 설정용. USBDP PHY가 없는 경우 반드시 정의해야 함.              |
| **rockchip,typec-vbus-det**   | Type-C의 VBUS_DET 핀 연결 시 사용하는 속성.                           |
| **rockchip,dis-u2-susphy**    | USB2 PHY의 suspend 진입 비활성화. USB 2.0 only 구성에서 PHY 클록 유지.    |


<br/>
<br/>
<br/>
<hr>

## USBDP Combo PHY Properties

> USB3.1 / DP 겸용 PHY 설정, 즉 Type-C DP Alt Mode 관련

 - usbdp_phy

| 속성                       | 설명                                                                                                                 |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------ |
| **rockchip,dp-lane-mux** | DP → USB PHY lane 매핑 설정.<br>예: `"rockchip,dp-lane-mux = <2,3>;"` → DP Lane0→USB PHY Lane2, DP Lane1→USB PHY Lane3. |
| **maximum-speed**        | “high-speed” 설정 시 USBDP PHY가 USB2.0 only로 제한됨.<br>→ 이 속성은 상위 usbdp_phy 노드에서 정의.                                    |


<br/>
<br/>
<br/>
<hr>

## USBC Properties

> Type-C Port Controller(IC) 관련 노드 구성

| 항목            | 설명                                                                                |
| ------------- | --------------------------------------------------------------------------------- |
| **usb 노드**    | 일반적으로 I2C 하위 노드. port / connector 두 가지 하위 노드를 포함.                                 |
| **port**      | role switch 역할과 연결. orientation switch, altmode mux 등 추가 서브노드 포함 가능.              |
| **connector** | `sink-pdos`, `source-pdos` 속성으로 Sink/Source 전력 능력 정의.<br>전압·전류 레벨이 PD 스펙과 일치해야 함. |

