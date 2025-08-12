#!/bin/bash

# 빠른 iOS Flutter 앱 실행 스크립트
# 사용법: ./quick_ios.sh [옵션]

# 색상 정의
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🚀 iOS Flutter 앱 빠른 실행${NC}"
echo ""

# 옵션 확인
case "$1" in
    "simulator"|"sim"|"s")
        echo -e "${YELLOW}📱 iOS 시뮬레이터에서 실행 중...${NC}"
        flutter run -d "iPhone 16 Plus"
        ;;
    "device"|"dev"|"d")
        echo -e "${YELLOW}📱 실제 기기에서 디버그 모드로 실행 중...${NC}"
        flutter run -d "00008120-0011096C1A53C01E"
        ;;
    "release"|"rel"|"r")
        echo -e "${YELLOW}📱 실제 기기에서 릴리즈 모드로 실행 중...${NC}"
        flutter run --release -d "00008120-0011096C1A53C01E"
        ;;
    "build"|"b")
        echo -e "${YELLOW}🔨 릴리즈 빌드 생성 중...${NC}"
        flutter build ios --release
        ;;
    "install"|"i")
        echo -e "${YELLOW}📲 앱 설치 중...${NC}"
        flutter install -d "00008120-0011096C1A53C01E"
        ;;
    "xcode"|"x")
        echo -e "${YELLOW}🛠️ Xcode 열기...${NC}"
        open ios/Runner.xcworkspace
        ;;
    "devices"|"list"|"l")
        echo -e "${YELLOW}📋 연결된 기기 목록:${NC}"
        flutter devices
        ;;
    *)
        echo "사용법: ./quick_ios.sh [옵션]"
        echo ""
        echo "옵션:"
        echo "  simulator, sim, s  - iOS 시뮬레이터에서 실행"
        echo "  device, dev, d     - 실제 기기에서 디버그 모드 실행"
        echo "  release, rel, r    - 실제 기기에서 릴리즈 모드 실행"
        echo "  build, b           - 릴리즈 빌드 생성"
        echo "  install, i         - 앱 설치"
        echo "  xcode, x           - Xcode 프로젝트 열기"
        echo "  devices, list, l   - 연결된 기기 목록 확인"
        echo ""
        echo "예시:"
        echo "  ./quick_ios.sh simulator"
        echo "  ./quick_ios.sh device"
        echo "  ./quick_ios.sh build"
        ;;
esac
