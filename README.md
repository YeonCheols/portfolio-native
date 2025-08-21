# Portfolio Native App

Flutter로 개발된 포트폴리오 앱입니다.

TO-BE 안드로이드 진행중..

## 🚀 빠른 시작

### iOS 앱 실행 및 빌드

#### 1. 대화형 스크립트 사용 (권장)

```bash
./tools/ios_build_run.sh
```

**메뉴 옵션:**

- 1. 연결된 기기 확인
- 2. iOS 시뮬레이터에서 실행
- 3. 실제 기기에서 디버그 모드 실행
- 4. 실제 기기에서 릴리즈 모드 실행
- 5. 릴리즈 빌드 생성
- 6. 앱 설치
- 7. Xcode 프로젝트 열기
- 8. 전체 과정 자동 실행 (빌드 → 설치 → 실행)
- 9. 종료

#### 2. 빠른 명령어 사용

```bash
# iOS 시뮬레이터에서 실행
./tools/quick_ios.sh simulator

# 실제 기기에서 디버그 모드 실행
./tools/quick_ios.sh device

# 실제 기기에서 릴리즈 모드 실행
./tools/quick_ios.sh release

# 릴리즈 빌드 생성
./tools/quick_ios.sh build

# 앱 설치
./tools/quick_ios.sh install

# Xcode 열기
./tools/quick_ios.sh xcode

# 연결된 기기 목록 확인
./tools/quick_ios.sh devices
```

#### 3. 수동 명령어

```bash
# iOS 시뮬레이터에서 실행
flutter run -d "iPhone 16 Plus"

# 실제 기기에서 디버그 모드 실행
flutter run -d "00008120-0011096C1A53C01E"

# 실제 기기에서 릴리즈 모드 실행
flutter run --release -d "00008120-0011096C1A53C01E"

# 릴리즈 빌드 생성
flutter build ios --release

# 앱 설치
flutter install -d "00008120-0011096C1A53C01E"
```

## 🛠️ 개발 도구

### 스크립트 파일들

프로젝트에는 iOS 개발을 위한 두 가지 스크립트가 `tools/` 폴더에 있습니다:

#### `tools/ios_build_run.sh`

- **대화형 메뉴 기반** iOS 앱 관리 도구
- 색상이 있는 로그 출력으로 사용자 친화적
- 9가지 옵션으로 완전한 iOS 앱 개발 워크플로우 제공
- 자동화된 빌드 → 설치 → 실행 과정

#### `tools/quick_ios.sh`

- **빠른 명령어 기반** iOS 앱 실행 도구
- 간단한 명령어로 즉시 실행 가능
- 개발 중 빠른 테스트에 최적화
- 다양한 옵션 지원 (simulator, device, release, build 등)

### 스크립트 사용법

```bash
# 대화형 도구 실행
./tools/ios_build_run.sh

# 빠른 명령어 사용
./tools/quick_ios.sh simulator    # 시뮬레이터 실행
./tools/quick_ios.sh device       # 실제 기기 디버그 실행
./tools/quick_ios.sh release      # 실제 기기 릴리즈 실행
./tools/quick_ios.sh build        # 릴리즈 빌드
./tools/quick_ios.sh install      # 앱 설치
./tools/quick_ios.sh xcode        # Xcode 열기
./tools/quick_ios.sh devices      # 기기 목록 확인
```

## 📱 앱 기능

- **웹뷰 포트폴리오**: `https://www.ycseng.com` 웹사이트를 앱 내에서 표시
- **새로고침**: 웹뷰 새로고침 기능
- **외부 브라우저 열기**: Safari에서 포트폴리오 열기
- **URL 설정**: 포트폴리오 URL 변경 기능
- **다크/라이트 테마**: 시스템 테마에 따른 자동 테마 변경
- **오류 처리**: 네트워크 오류 시 재시도 및 외부 브라우저 옵션 제공

## 🔧 개발 환경

- **Flutter**: 3.32.8
- **Dart**: 3.8.1
- **iOS**: 18.5+
- **Xcode**: 16.4+

## 📦 의존성

```yaml
dependencies:
  flutter:
    sdk: flutter
  url_launcher: ^6.2.5
  shared_preferences: ^2.2.2
  webview_flutter: ^4.7.0
```

## 🛠️ 문제 해결

### 개발자 앱 신뢰 문제

실제 기기에서 앱을 실행할 때 "신뢰하지 않는 개발자" 오류가 발생하는 경우:

1. **iPhone 설정** → **일반** → **VPN 및 기기 관리**
2. **Apple Development** 프로필 찾기
3. **신뢰** 버튼 클릭

### 앱이 실행되지 않는 경우

1. Flutter 환경 확인: `flutter doctor`
2. 기기 연결 확인: `flutter devices`
3. Xcode에서 직접 실행: `open ios/Runner.xcworkspace`

### 스크립트 실행 권한 문제

```bash
# 스크립트에 실행 권한 부여
chmod +x tools/ios_build_run.sh
chmod +x tools/quick_ios.sh
```

## 📁 프로젝트 구조

```
portfolio-native/
├── lib/
│   └── main.dart              # 메인 앱 코드
├── ios/                       # iOS 프로젝트 파일
├── android/                   # Android 프로젝트 파일
├── tools/                     # 개발 도구 스크립트
│   ├── ios_build_run.sh      # 대화형 iOS 빌드/실행 도구
│   └── quick_ios.sh          # 빠른 iOS 명령어 도구
├── pubspec.yaml              # Flutter 의존성 설정
└── README.md                 # 프로젝트 문서
```

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.
