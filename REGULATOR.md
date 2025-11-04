REGULATOR
====

<br/>
<br/>
<br/>
<br/>
<hr>

# RK3576 POC Power Summary

<br/>
<br/>
<br/>
<hr>

## 1. Power Supply Overview

| 구분 | 전원명 | 전압 (V) | 공급원 | 주요 용도 / 대상 | 상태 | 비고 |
|------|---------|-----------|--------|------------------|--------|------|
| 입력전원 | VCC12V_DCIN | 12.0 | 외부 어댑터 | 전체 시스템 전원 | Always ON | |
| 입력전원 | VCC5V0_SYS_S5 | 5.0 | EXT BUCK | 시스템 메인 / PMIC 입력 | Always ON | |
| 입력전원 | VCC5V0_DEVICE_S0 | 5.0 | EXT BUCK | USB Host / 장치전원 | S0 only | |
| 시스템전원 | VCC3V3_SYS_S3 | 3.3 | DCDC | IO, Sensor, PMIC | S3 유지 | |
| 시스템전원 | VCC1V8_S3 | 1.8 | LDO | IO, Logic, Sensor | S3 유지 | |
| 코어전원 | VDD_LOGIC_MEM_S0 | 0.9 | BUCK | SoC 내부 Logic | S0 only | |
| 코어전원 | VDD_CPU_BIG_S0 | 0.85 | BUCK | Cortex-A76 | S0 only | DVFS |
| 코어전원 | VDD_CPU_LIT_S0 | 0.85 | BUCK | Cortex-A55 | S0 only | DVFS |
| 코어전원 | VDD_GPU_S0 | 0.75 | BUCK | Mali GPU | S0 only | |
| 코어전원 | VDD_NPU_S0 | 0.75 | BUCK | NPU Core | S0 only | |
| 메모리전원 | VDD_DDR_S0 | 1.2 | BUCK | DDR4 Core | S0 only | |
| 메모리전원 | VDDQ_DDR_S0 | 1.2 | BUCK | DDR4 I/O | S0 only | |
| 메모리전원 | VPP_DDR_S0 | 2.5 | LDO | DDR4 VPP (ACT) | S0 only | |
| 메모리전원 | VDDA_DDR_PLL_S0 | 0.9 | LDO | DDR PHY PLL | S0 only | |
| 아날로그 | VDDA_0V75_S0 | 0.75 | LDO | MIPI, HDMI PHY | S0 only | |
| 아날로그 | VDDA_1V8_S0 | 1.8 | LDO | MIPI, HDMI PHY | S0 only | |
| 주변기기 | VCCIO_SD_S0 | 3.3 / 1.8 | LDO | SD 카드, GPIO | S0 only | |
| 주변기기 | VCCIO_UART_S0 | 3.3 | LDO | UART, GPIO | S0 only | |
| 주변기기 | VCCIO_CAM_S0 | 1.8 / 3.3 | LDO | Camera, MIPI IO | S0 only | |
| 보조전원 | RTC_3V0 / VBAT | 3.0 | Coin Cell | RTC 유지 | Always ON | |
| 제어 | RESET_L | — | Signal | 전원 안정화 후 해제 | Sequence End | |

<br/>
<br/>
<hr>

### 1.1. 입력 전원(Input Stage)

 - VCC12V_DCIN : 외부 어댑터 입력 전원. 전체 보드의 전원 공급 시작점. PMIC와 외부 DCDC 변환기로 분배 됨.   
 - VCC5V0_SYS_S5 : 12V를 변환해 항상 켜져 잇는 시스템 전원. PMIC, USB 5V, LED, 팬, RTC 회로 등에 공급 됨.  
 - VCC5V0_DEVICE_S0 : USB Host 및 주변장치용 5V 전원. 시스템이 S0(Active) 상태일 때만 활성화됨. 

<br/>
<br/>
<hr>

### 1.2. PMIC 기반 주요 전원(Core & Subsystem)

 - VDD_CPU_BIG_S0 : 고성능 CPU 코어용. DVFS(동적 전압조절) 지원.
 - VDD_CPU_LIT_S0 : 저전력 CPU 코어용. DVFS 지원.
 - VDD_GPU_S0 : 그래픽 블록용. DVFS로 클럭/전압 동기 조절.
 - VDD_NPU_S0 : AI 연산 전용 NPU 블록용.
 - VDD_LOGIC_MEM_S0 : 내부 버스, 캐시, 컨트롤러 구동용 기본 전원
 - VCC1V2_NLDO_S3 : IO PHY 아날로그 회로용. 슬립 시 유지 필요.
 - VCC1V8_S3 : SoC와 외부장치의 신호 레벨 기준.
 - VCC3V3_SYS_S3 : 대다수 외부 IO 및 보조 회로 전원.

<br/>
<br/>
<hr>

### 1.3. 메모리 전원(DDR / LPDDR4X) 

 - VDD_DDR_S0 : DDR Core 구동 전원. DRAM 내부 로직이 동작하는 핵심 전압.
 - VDDQ_DDR_S0 : DDR I/O 신호 레벨용 전원. (DQ, DQS, ADDR, CMD 라인 전송 시 사용)
 - VPP_DDR_S0 : DDR ACT 동작 전원. Bank Activate 시 내부 고전압 트랜지스터 구동용.
 - VDDA_DDR_PLL_S0 : DDR PHY PLL용 전원. 클럭 동기화 회로용 아날로그 레일.

<br/>
<br/>
<hr>

### 1.4. 아날로그 / 비디오 / 센서 전원  

 - VDDA_0V75_S0 : HDMI / MIPI PHY 내부 아날로그 회로용
 - VDDA_1V8_S0 : HDMI PHY, Camera MIPI 회로용
 - VCCA_1V8_S0 : Analog Codec, Audio ADC/DAC, Sensor 전원
 - VCCA_3V3_S0 : 고전압 Analog 회로용 (AMP, ADC)
 - VCCIO_SD_S0 : 또는 1.8V	SD/MMC IO 전압 (카드 타입에 따라 선택)

<br/>
<br/>
<hr>

### 1.5. 외부 주변기기 및 IO 전원 

 - VCCIO_CAM_S0 : MIPI CSI/DSI 카메라 IO
 - VCCIO_UART_S0 : UART 통신
 - VCCIO_GPIO_S0 : 일반 GPIO IO
 - VCCIO_SD_S0 : / SD 카드 신호 IO
 - VCCIO_AUDIO_S0 : Audio Codec I2S / I2C 통신선

<br/>
<br/>
<hr>

### 1.6. Power Sequence 순서 요약   

| 단계     | 주요 전원                          | 동작 내용                  |
| ------ | --------------------------------- | ------------------------ |
| Step 0 | VCC12V_DCIN, VCC5V0_SYS_S5        | 외부 입력 및 메인 5V 기동     |
| Step 1 | VCC3V3_SYS_S3, VCC1V8_S3          | IO / Logic 초기화          |
| Step 2 | VDD_LOGIC_MEM_S0, CPU/GPU/NPU     | SoC 내부 블록 전원 인가      |
| Step 3 | DDR 관련 전원 (VDD, VDDQ, VPP, PLL) | 메모리 초기화               |
| Step 4 | Analog / PHY 전원                  | MIPI, HDMI, PCIe PHY 준비 |
| Step 5 | RESET_L 해제                       | 부팅 시작 (BootROM 동작)    |

<br/>
<br/>
<hr>

### 1.7. S-State 동작 개념

| 상태 | 의미	         | 유지 전원                           |
| --- | ------------ | --------------------------------- |
| S0  |	Active Mode  | 모든 전원 ON                        |
| S3  |	Suspend Mode |	1.8V / 3.3V / 1.2V IO만 유지       |
| S5  |	Power Off    |	최소 전원 (RTC, PMIC, 5V_SYS)만 유지 |

<br/>
<br/>
<br/>
<hr>

## 2. IO Power Domain Map

| IO Domain | 공급 전원 | 동작 전압 | 비고 |
|------------|------------|------------|------|
| PMUIO0 | VCCIO0_VCC | 1.8V / 3.3V | IO Bank 0 |
| PMUIO1 | VCCIO1_VCC | 1.8V | PMIC IO |
| VCCIO2 | VCCIO2_VCC | 1.8V / 3.3V | IO Bank 2 |
| VCCIO3 | VCCIO3_VCC | 1.8V / 3.3V | IO Bank 3 |
| VCCIO4 | VCCIO4_VCC | 1.8V / 3.3V | IO Bank 4 |
| VCCIO6 | VCCIO6_VCC | 1.2V / 1.8V | DDR IO |
| VCCIO7 | VCCIO7_VCC | 1.2V / 1.8V | DDR PHY IO |

<br/>
<br/>
<br/>
<hr>

## 3. Power Sequence

| 순서 | 주요 전원 | 설명 |
|------|-------------|------|
| 1 | VCC12V_DCIN, VCC5V0_SYS_S5 | 입력 전원 인가 |
| 2 | VCC3V3_SYS_S3, VCC1V8_S3 | IO 및 기본 Rail |
| 3 | VDD_LOGIC_MEM_S0, CPU/GPU/NPU | SoC 전원 인가 |
| 4 | VDD_DDR / VPP_DDR / PLL | 메모리 / PHY 안정화 |
| 5 | RESET_L | 부팅 시퀀스 시작 |

<br/>
<br/>
<br/>
<hr>

## 4. Note
- **S0:** Power Off during sleep  
- **S3:** Power 유지 during sleep  
- **S5:** Always On  
- **DVFS 지원:** CPU, GPU 전원 동적조절 지원  
- **IO Leakage 주의:** SoC와 주변기기 IO 전압 동시 인가 필요


<br/>
<br/>
<br/>
<br/>
<hr>

# RK3576 EVB Power Summary

<br/>
<br/>
<br/>
<hr>

## 1. Power Supply Overview

| 구분 | 전원명 | 전압 (V) | 공급원 | 주요 용도 / 대상 | 상태 | 비고 |
|------|---------|-----------|--------|------------------|--------|------|
| 입력전원 | VCC12V_DCIN | 12.0 | 어댑터 | 메인 입력 | Always ON | |
| 입력전원 | VCC5V0_SYS_S5 | 5.0 | EXT BUCK | PMIC 입력 / Always On | S5 유지 | |
| 입력전원 | VCC5V0_DEVICE_S0 | 5.0 | EXT BUCK | USB 장치 | S0 only | |
| 시스템전원 | VCC3V3_SYS_S3 | 3.3 | EXT BUCK | IO / Sensor / Logic | S3 유지 | |
| 시스템전원 | VCC1V8_S3 | 1.8 | SWITCH | Logic IO | S3 유지 | |
| 코어전원 | VDD_CPU_BIG_S0 | 0.85 | RK806_BUCK1 | Big Core | DVFS | |
| 코어전원 | VDD_CPU_LIT_S0 | 0.85 | RK806_BUCK2 | Little Core | DVFS | |
| 코어전원 | VDD_GPU_S0 | 0.75 | RK806_BUCK4 | GPU | S0 only | |
| 코어전원 | VDD_NPU_S0 | 0.75 | RK806_BUCK5 | NPU | S0 only | |
| 코어전원 | VDD_LOGIC_MEM_S0 | 0.9 | RK806_BUCK6 | Logic & Memory | S0 only | |
| 메모리전원 | VDD_DDR_S0 | 1.2 | RK806_BUCK7 | DDR4 Core | S0 only | |
| 메모리전원 | VPP_DDR_S0 | 2.5 | RK806_PLDO3 | DDR4 VPP | S0 only | |
| 메모리전원 | VDDA_DDR_PLL_S0 | 0.9 | RK806_NLDO2 | DDR PHY PLL | S0 only | |
| 아날로그 | VDDA_0V75_S0 | 0.75 | RK806_NLDO5 | PHY Analog | S0 only | |
| 아날로그 | VDDA_1V8_S0 | 1.8 | RK806_PLDO4 | HDMI, MIPI | S0 only | |
| 주변기기 | VCCIO_SD_S0 | 3.3 / 1.8 | EXT LDO | SD, GPIO | S0 only | |
| 주변기기 | VCCIO_UART_S0 | 3.3 | EXT LDO | UART | S0 only | |
| 주변기기 | VCCIO_CAM_S0 | 1.8 / 3.3 | EXT LDO | MIPI Camera | S0 only | |
| 보조전원 | RTC_3V0 / VBAT | 3.0 | Coin Cell | RTC | Always ON | |
| 제어 | RESET_L | — | Signal | Reset after Power Stable | Sequence End | |

<br/>
<br/>
<br/>
<hr>

## 2. IO Power Domain Map

| IO Domain | 공급 전원 | 동작 전압 | 설명 |
|------------|------------|------------|------|
| PMUIO0 | VCCIO0_VCC | 1.8V / 3.3V | PMIC IO |
| PMUIO1 | VCCIO1_VCC | 1.8V | IO Bank 1 |
| VCCIO2 | VCCIO2_VCC | 1.8V / 3.3V | IO Bank 2 |
| VCCIO3 | VCCIO3_VCC | 1.8V / 3.3V | IO Bank 3 |
| VCCIO4 | VCCIO4_VCC | 1.8V / 3.3V | IO Bank 4 |
| VCCIO6 | VCCIO6_VCC | 1.2V / 1.8V | DDR IO |
| VCCIO7 | VCCIO7_VCC | 1.2V / 1.8V | DDR PHY IO |

<br/>
<br/>
<br/>
<hr>

## 3. Power Sequence (Timing Slot)

| Slot | 주요 전원 | 설명 |
|------|------------|------|
| Slot0 | VCC12V_DCIN, VCC5V0_SYS_S5 | 메인 입력 |
| Slot1 | VCC3V3_SYS_S3, VCC1V8_S3 | 기본 IO |
| Slot2 | CPU / GPU / NPU / DDR | SoC 코어 |
| Slot3~7 | DDR4 및 PLL | 메모리 안정화 |
| Slot12 | RESET_L | 리셋 해제 후 부팅 시작 |

<br/>
<br/>
<br/>
<hr>

## 4. Note
- **Suffix 의미**
  - S0: Power off during sleep
  - S3: Keep on during sleep
  - S5: Always on
- **DVFS:** CPU/GPU 전원 동적 조절 가능
- **주의:** GPIO와 주변기기 IO 전압 동시 인가 필수

