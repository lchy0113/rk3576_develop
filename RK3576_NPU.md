
RK3576 NPU
====

<br/>
<br/>
<br/>
<br/>
<hr>

# Roadmap

<br/>
<br/>
<br/>
<hr>

## RK NPU 하드웨어 구조 

 - RKNPU2 기반 NPU
 - INT8/FP16 연산 지원


<br/>
<br/>
<br/>
<hr>

##  Rockchip NPU 모델 변환 과정(RKNN ToolKit)  

Rockchip NPU를 사용하려면 Deep Learning 모델을 Rockchip 전용 포맷인 **RKNN 파일** 로 변환해야 함.  

 변환 툴  
 - RKNN-Toolkit2(Python 기반)
   * 지원 프레임워크: TensorFlow, TensorFlow Lite, ONNX, PyTorch(→ONNX 변환 통해 지원)  
   * Quantization 지원(INT8, Hybrid)  

 변환 단계  
 1. 학습된 모델 준비.
 2. ONNX 변환(필요시)
 3. Dataset 구성(정량화용 Calibration dataset)
 4. RKNN ToolKit 으로 변환
 5. Simulator 또는 Linux/Android 보드에서 테스트

예
```python
from rknn.api import RKNN

rknn = RKNN()
rknn.load_onnx('your_model.onnx')
rknn.build(do_quantization=True, dataset='dataset.txt')
rknn.export_rknn('your_model.rknn')
```

<br/>
<br/>
<br/>
<hr>

## Android/Linux 환경에서의 RKNN Runtime 활용

 런타임 구성 요소  
 - librknnrt.so
 - rknn_api.h
 - 드라이버: rknpu2 드라이버(Kernel module)

 기본 실행 흐름  
 - RKNN 모델 로드
 - Input tensor 설정
 - NPU interface 실행
 - Output tensor 획득
 - 후처리(post-processing)

<br/>
<br/>
<br/>
<hr>

## RK 플랫폼에서 NPU+카메라 파이프라인 구성 이해

RK 플랫폼에서 ISP/MIPI CSI 구조를 사용함.  
```
Camera → MIPI CSI → ISP → RGA / Zero-copy → NPU → 결과 → App

```

 YOLO / 얼굴인식 / 객체 추적 Demo
 Rockchip은 Android 및 Linux 용 NPU Demo를 SDK에 포함하고 있음.  
 - Camera_demo
 - yolov5_rknn_demo
 - object_detection_demo 등

<br/>
<br/>
<br/>
<br/>
<hr>

# RK NPU

<br/>
<br/>
<br/>
<hr>

## Develop environment

 - dev-rkllm Docker 구성
 - docker 내 Minoforge3를 통해 RKNN, RKLLM 개발 환경 구성

```
Miniforge3
 ├── envs/RKLLM-Toolkit
 └── envs/RKNN-Toolkit2
```

```
conda create -n RKNN-Toolkit2 python=3.10 -y
conda activate RKNN-Toolkit2
python -m pip install --upgrade pip
python -m pip install /home/lchy0113/develop/Rockchip/RKLLM/airockchip/rknn-toolkit2/rknn-toolkit2/packages/x86_64/rknn_toolkit2-2.3.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
```

```
conda env list

# conda environments:
#
# * -> active
# + -> frozen
RKNN-Toolkit2            /home/lchy0113/.conda/envs/RKNN-Toolkit2
base                     /opt/miniforge3
RKLLM-Toolkit        *   /opt/miniforge3/envs/RKLLM-Toolkit
```

<br/>
<br/>
<br/>
<hr>

## RKNPU 를 사용방법  
 1. RKLLM-Toolkit을 PC에 설치
 2. HuggingFace LLM → RKLLM format (.rkllm) 변환
 3. RKLLM Runtime (C API)로 추론 실행

<br/>
<br/>
<br/>
<hr>

## RKNPU 의 종류 (RKNN vs RKLLM)
 RKNPU는 2가지 라인이있음. 

 - RKNN (일반 AI, YOLO 등) 
 1. rknn-toolkit 설치 (https://github.com/airockchip/rknn-toolkit2)
 2. ONNX/TensorFlow 모델 → .rknn 변환
 3. rknn-runtime API로 추론
   
   * Rockchip Neural Network : Rockchip NPU에서 실행되는 일반 AI 모델 프레임워크
   * 거의 NPU 중심
   * ONNX : 학습된 모델을 교환하기 위한 표준 포멧(다양한 프레임워크 간 모델 교환용 표준 포멧)
   * TensorFlow : AI모델을 만들고 학습하는 프레임워크(구글이 만든 딥러닝 프레임워크)

 - RKLLM (LLM전용)
 1. RKLLM-Toolkit 설치 (https://github.com/airockchip/rknn-llm.git)
 2. HuggingFace LLM → .rkllm 변환
 3. rkllm-runtime API로 추론

   * Rockchip Large Language Model : Rockchip에서 LLM을 실행하기 위한 전용 프레임워크
   * NPU만 사용하지 않음. 
   * CPU + NPU + 메모리 혼합 구조. 

<br/>
<br/>
<br/>
<hr>

## rkllm_api

<br/>
<br/>
<hr>

### data_quant.json

 data_quant.json 파일은 RKLLM(예: DeepSeek-R1-Distill-Qwen-1.5B 등) 모델을 양자화(quantization)   
 할때 사용하는 "양자화 보정(calibation) 데이터"를 담고 있는 파일  

 주요 내용:
   - 역할 : 모델을 INT8 등 저정밀도로 변환할때, 원본 FP16(또는 FP32)모델의 출력 분포를  
   대표하는 입력/출력 데이터를 저장.  
   - 생성 방법 : 일반적으로 FP16 모델로 여러 입력(예:텍스트 프롬프트 등)을 추론하여,  
   내부 텐서의 통계깞(최대/최소, 평균 등) 을 수집해 data_quant.json에 기록.  
   - 사용 위치 : export_rkllm.py 등 양자화 변환 스크립트에서 이 파일을 읽어서,   
   실제 양자화 변환 시 정밀도 손신을 최소화하도록 보정한다.  
  
<br/>
<br/>
<br/>
<br/>
<hr>

# Deploy MODEL

 - Host
```
lchy0113@hsdev:~/develop/Rockchip/RKLLM/models$ ssh -p 9032 lchy0113@localhost 
lchy0113@localhost's password: 
Last login: Thu Mar 26 16:36:40 2026 from 172.22.0.1
lchy0113@6f67c01f2936:~$ ls
bin  Desktop  develop  Documents  Downloads  gitconfig  hdd  Music  Pictures  platform  Private  Public  snap  src  Templates  Videos  work
lchy0113@6f67c01f2936:~$ 
lchy0113@6f67c01f2936:~$ conda activate rkllm

EnvironmentNameNotFound: Could not find conda environment: rkllm
You can list all discoverable environments with `conda info --envs`.


lchy0113@6f67c01f2936:~$ conda info --envs

# conda environments:
#
# * -> active
# + -> frozen
base                     /opt/miniforge3
RKLLM-Toolkit        *   /opt/miniforge3/envs/RKLLM-Toolkit

lchy0113@6f67c01f2936:~$ conda activate RKLLM-Toolkit
(RKLLM-Toolkit) lchy0113@6f67c01f2936:~$ 

```

```
# Install RKLLM-Toolkit, such as rkllm toolkit-1.2.3
pip3 install 
./rkllm-toolkit/packages/rkllm_toolkit-1.2.3-cp312-cp312-linux_x86_64.whl
./rkllm-toolkit/packages/rkllm_toolkit-1.2.3-cp39-cp39-linux_x86_64.whl
./rkllm-toolkit/packages/rkllm_toolkit-1.2.3-cp310-cp310-linux_x86_64.whl
./rkllm-toolkit/packages/rkllm_toolkit-1.2.3-cp311-cp311-linux_x86_64.whl

```

 - Device
```
rkllm_env-develop.env 
# Toolchain for building 

# for rkllm
export TOOLCHAIN_ROOT=/home/lchy0113/develop/Rockchip/RKLLM/TOOLCHAIN/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu
export GCC_COMPILER_PATH=${TOOLCHAIN_ROOT}/bin/aarch64-none-linux-gnu
export PATH=${TOOLCHAIN_ROOT}/bin:$PATH

```

<br/>
<br/>
<br/>
<hr>

## QWEN 

📌 RKLLM 실행 환경 메모 (Qwen2.5-1.5B)
1. 실행 환경
경로: ~/rkllm
모델: Qwen2.5-1.5B-Instruct.rkllm
실행 바이너리: llm_demo
플랫폼: RK3576 Debian

✔️ 정상 실행 명령
LD_LIBRARY_PATH=/home/linaro/rkllm/lib/ \
./llm_demo Qwen2.5-1.5B-Instruct.rkllm 1024 2048


5. 파라미터 의미 (확인 필요)
./llm_demo <model> <param1> <param2>

현재 사용값:

1024 2048

⚠️ 주의

정확한 의미는 현재 코드/SDK 기준으로 명확히 확인되지 않음
일반적으로:
param1: input token length 또는 prompt length
param2: max output length 또는 context 설정
👉 (추측 아님: 확정 불가 상태 → 코드 확인 필요)

<br/>
<br/>
<br/>
<br/>
<hr>

# Note

<br/>
<br/>
<br/>
<hr>

## INT8/FP16 연산 지원이 실제로 필요한 단계

 1. 모델 변환 단계(Quantization 단계)
 **가장 중요**  
 Rockchip NPU는 INT8 정량화 (Quantization) 된 모델에서 최고의 성능을 발휘함.  
 따라서 RKNN ToolKit 으로 모델을 변환할때 아래 선택 필요.  

 ✔ FP32 원본 모델 → INT8 변환(Quantization)

 모델 빌드(build)시점.  

 2. NPU 런타임에서 모델 실행 시(HW연산 Precision고려)
  
➡ 실행 자체에는 선택 옵션이 없는 경우가 많지만, 모델이 어떤 precision을 사용하는지 알아야 함  
NPU는 모델의 텐서 타입(model tensor type)을 기준으로 연산 방식을 결정.  
  
예:  
INT8 모델이면 NPU는 INT8 행렬연산으로 실행  
FP16 모델이면 FP16 연산으로 실행  
✔ 즉, 런타임에서 따로 “INT8로 실행해줘”라고 설정하는 것이 아니라,  
'모델 변환 단계에서 이미 연산 형태가 결정'되어 있음  

<br/>
<br/>
<br/>
<hr>

## Tensor란

 Tensor란 수학적으로 "다차원 배열" 의미.  
 딥러닝, NPU, RKNN, PyTorch, TensorFlow 모두 이 구조를 사용  

Tensor 구성

| 텐서 종류               | 차원 수 | 예시          | 의미               |
| ----------------------- | ------- | ------------- | ---------------- |
| **0차원 텐서 (Scalar)** | 0       | 7             | 숫자 하나            |
| **1차원 텐서 (Vector)** | 1       | [1, 2, 3]     | 배열               |
| **2차원 텐서 (Matrix)** | 2       | [[1,2],[3,4]] | 행렬               |
| **3차원 텐서**          | 3       | 28×28×1       | 흑백 이미지           |
| **4차원 텐서**          | 4       | 1×224×224×3   | 컬러 이미지(batch 포함) |
| **N차원 텐서**          | N       | …             | 딥러닝 모든 데이터 표현    |

<br/>
<br/>
<br/>
<hr>

## Weight 와 Activation 

 - Weight (가중치): 모델이 학습하면서 얻은 **고정된 파라미터 값**
```
y = w1 * x1 + w2 * x2 +b 
```
   * w1, w2 -> weight
   * b -> bias


 - activation (활성값) : 입력이 모델을 통과하면서 중간 계산으로 생성되는 값
```
입력 -> [Layer1] -> [Layer2] -> 출력
```

   * Layer 1 출력 = activation
   * Layer 2 입력 = activation
   
  
LLM 기준으로 보면,   
 Weight  
  - 수십억 개 존재(2B = 20억 개)
  - Transformer 내부의 모든 데이터
  - 모델 크기를 결정함.  
  
 Activation  
  - 토근이 지나가면서 생성됨  
  - Attention, FFN 등 모든 레이어에서 발생 
  - 메모리 사용량에 큰 영향  
  
  
  양자화 관점에서 차이  
  - Weight Quantization
    * 모델 파일 크기 줄임.
    * 예: FP32 -> INT8/INT4
    * 영향: 저장 용량 + 연산 속소

  - Activation Quantization 
    * 실행 시 메모리 줄임 
    * 예: FP16 -> INT8
    * 영향: 런타임 메모리 + NPU 사용률  
  
  
 W8A8 / W4A16 의미

| 표기  | 의미                          |
| ----- | ----------------------------- |
| W8A8  | weight=8bit, activation=8bit  |
| W4A16 | weight=4bit, activation=16bit |

<br/>
<br/>
<br/>
<hr>

## Token(토큰)

 문장을 모델이 처리할 수 있도록 쪼갠 최소 단위. 

 예시)
```
 문장 : I love ChatGPT
```
 
 토큰화 결과 :
```
["I", " love", " Chat", "GPT"]
```

 숫자로 변환  
> 토큰은 결국 ID로 변환  

```
"I" -> 123
" love" -> 456
```

<br/>
<br/>
<hr>

### 전체 흐름

```
문장 -> Token -> Token ID -> Embdding -> Transformer -> 출력
```

<br/>
<br/>
<hr>

### Weight / Activation 흐름

<br/>
<hr>

#### Step1. Token -> Embedding

```
token_id -> embedding vector (예: 2048차원)
```
 - embedding matrix = Weight  
 - 결과벡터 : Activation

<br/>
<hr>

#### Step2. Transformer Layer (반복)

```
Activation_in * Weight -> Activation_out 
```

<br/>
<hr>

#### Step3. Attention 계산


<br/>
<hr>

#### Step4. FFN (Feed Forward)


<br/>
<br/>
<hr>

### 2B 모델 기준으로 보면

 - Weight 
   * 약 20억 개 
   * 모델 전체에 고정 
   * 파일로 존재
   * "뇌 구조"

 - Activation
   * 토큰이 들어올 때마다 생성
   * 레이어마다 계속 생성/소멸


