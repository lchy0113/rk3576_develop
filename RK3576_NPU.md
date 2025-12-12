
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

