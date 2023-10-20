# 💬 실시간 번역
카메라로 글자를 스캔하세요.
스캔 된 언어를 자동으로 인식하고, 지정된 언어로 번역합니다.
번역된 내용은 스캔 된 글자 위에 보여집니다.

## 🔢 목차
1. [프로젝트 세팅](#프로젝트-세팅)
2. [실행 화면](#실행-화면)
3. [트러블 슈팅](#트러블-슈팅)
4. [참고 링크](#참고-링크)

<a id="프로젝트-세팅"></a>

## 📢 프로젝트 세팅
- 프로젝트를 실행하기 위해 iOS 16.0+ 이상의 실제 디바이스가 필요합니다.
- 프로젝트 폴더 내에 `NaverAPIKey.plist` 파일을 생성해주어야 합니다.<br/>
![](https://github.com/bubblecocoa/storage/assets/67216784/4c4d2afb-f31f-48a4-b461-82c1fce8e272)
- `NaverAPIKey.plist` 내에 필요한 프로퍼티는 `ClientID`, `ClientSecret`입니다.<br/>
![](https://github.com/bubblecocoa/storage/assets/67216784/57463838-136d-478f-a157-f0b6ab0939e0)
- 각 프로퍼티에 필요한 값은 [Papago 번역 특징](https://developers.naver.com/docs/papago/papago-nmt-overview.md#papago-%EB%B2%88%EC%97%AD-%ED%8A%B9%EC%A7%95) 문서를 참고하여 발급받아 진행합니다.

<a id="실행-화면"></a>

## 📱 실행 화면
|권한 확인|실시간 번역|
|:-:|:-:|
|![camera_permission](https://github.com/bubblecocoa/storage/assets/67216784/960bf888-212b-4162-b37e-aa6323533c5f)|![translation_ko_1](https://github.com/bubblecocoa/storage/assets/67216784/20e823d6-8b25-4a59-8341-95481719ca51)|

|원문 & 번역 바텀시트|언어 변경|
|:-:|:-:|
|![translation_ko_2](https://github.com/bubblecocoa/storage/assets/67216784/951571ab-e098-40c8-a4a3-9899fb4aa09a)|![change_target_language](https://github.com/bubblecocoa/storage/assets/67216784/45b9af10-4418-4476-b73f-e2b11d0366f8)|

<a id="트러블-슈팅"></a>

## 🚀 트러블 슈팅
### 🚨 실시간 텍스트 인식
#### 🔥 문제점
- '카메라로 비추고 있는 위치의 텍스트를 인식하여 실시간으로 번역을 제공합니다.' 라는 요구사항 중 '텍스트를 인식하여' 라는 부분에만 집중하여 `Live Text API`를 알아보았습니다.
- 애플에서 제공하는 `Live Text API`는 `ImageAnalyzer`를 이용하는데, 이는 사진이나 일시정지 된 비디오 프레임으로부터 텍스트 정보를 가져올 수는 있지만 실시간 비디오로부터 정보를 가져오지는 못했습니다. 때문에 '실시간으로 번역을 제공합니다.' 라는 요구사항은 만족할 수 없었습니다.
- `AVFoundation`과 `Vision` 프레임워크를 결합하여 데이터를 처리하는 방법도 있으나, 많은 과정을 거쳐야 했기 때문에 매우 어렵고 시간이 오래 걸리는 작업이 되었을 것입니다.
#### 🧯 해결방법
- iOS 16에서는 `AVFoundation`과 `Vision`을 모두 캡슐화하는 새로운 `VisionKit` 프레임워크가 출시되었습니다.
- `VisionKit`의 `DataScannerViewController`는 위의 고민을 단번에 해결해주는 새로운 옵션입니다.
- `DataScannerViewController`는 **비디오**로 스캔한 텍스트 정보를 원문과 함께 스캔 된 원문의 `bounds`까지 알려주기 때문에 해당 위치에 번역 된 문자를 다시 띄워줄 수 있었습니다.

### 🚨 번역 API 선택
#### 🔥 문제점
- iOS는 번역앱을 내장하고 있지만 개발자가 활용할 수 있는 번역에 대한 API는 제공해주고 있지 않았습니다.
- 때문에 번역을 위해서는 외부 번역 API 서비스를 이용해야 했습니다.
- 비교를 위해 `DeepL`, `Naver Papago`, `Kakao i Cloud Translation`, `Google Cloud Translation` 등의 서비스를 찾아보았습니다.
#### 🧯 해결방법
- 무료 및 유료 플랜에서 `Google Cloud Translation` 혹은 `AWS`나 `Azure`에서 제공하는 번역 서비스가 가장 매력적이었습니다.
- 하지만 공공API, 오픈API만 사용 가능이라는 제한 상 해당 서비스는 이용할 수 없었습니다.
- 비교에 이용된 서비스들 중 `Naver Papago`만이 `Papago 번역은 비로그인 방식 오픈 API입니다.` 라는 공식적인 설명이 있었기 때문에 최종적으로 `Papago` 서비스가 채택되었습니다.

### 🚨 번역 자세히 보기
#### 🔥 문제점
- `DataScannerViewController`로 데이터를 스캔시 `recognizesMultipleItems`옵션을 `true`로 지정하는 경우 화면 내 모든 문자를 인식합니다.
- 이 경우 단일 건 인식보다 문자 인식이 더 빈번하게 일어나게 되고, 사용자가 번역을 확인하기 전에 UI가 업데이트 될 수 있습니다.
#### 🧯 해결방법
- `DataScannerViewControllerDelegate`의 `dataScanner(_:didTapOn:)` 메서드를 이용해 인식된 문자를 터치했을 때 인식된 문자와 번역된 `sheetPresentationController`의 `detents` 옵션 값을 `[.medium()]`로 주어 화면의 절반만 차지하는 모달 시트를 띄워 원문과 번역을 동시에 볼 수 있게 했습니다.

<a id="참고-링크"></a>

## 🔗 참고 링크
- [🍎 Developer Apple - Enabling Live Text interactions with images](https://developer.apple.com/documentation/visionkit/enabling_live_text_interactions_with_images)
- [🍎 Developer Apple - VisionKit](https://developer.apple.com/documentation/visionkit)
- [🍎 Developer Apple - DataScannerViewController](https://developer.apple.com/documentation/visionkit/datascannerviewcontroller)
- [🍎 Developer Apple - UISheetPresentationController](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller)
- [🧑‍💻 WWDC 2022 - Capture machine-readable codes and text with VisionKit](https://developer.apple.com/videos/play/wwdc2022/10025)
- [🧑‍💻 WWDC 2022 - Add Live Text interaction to your app](https://developer.apple.com/videos/play/wwdc2022/10026)
