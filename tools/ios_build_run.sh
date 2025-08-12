#!/bin/bash

# iOS Flutter 앱 빌드 및 실행 스크립트
# Author: Portfolio Native App

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 함수: 로그 출력
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 함수: 기기 목록 확인
check_devices() {
    log_info "연결된 기기 확인 중..."
    flutter devices
    echo ""
}

# 함수: 시뮬레이터 실행
run_simulator() {
    log_info "iOS 시뮬레이터에서 앱 실행 중..."
    flutter run -d "iPhone 16 Plus"
}

# 함수: 실제 기기에서 디버그 모드 실행
run_device_debug() {
    log_info "실제 기기에서 디버그 모드로 앱 실행 중..."
    flutter run -d "00008120-0011096C1A53C01E"
}

# 함수: 실제 기기에서 릴리즈 모드 실행
run_device_release() {
    log_info "실제 기기에서 릴리즈 모드로 앱 실행 중..."
    flutter run --release -d "00008120-0011096C1A53C01E"
}

# 함수: 릴리즈 빌드
build_release() {
    log_info "iOS 릴리즈 빌드 생성 중..."
    flutter build ios --release
    if [ $? -eq 0 ]; then
        log_success "릴리즈 빌드 완료!"
        log_info "빌드된 앱 위치: build/ios/iphoneos/Runner.app"
    else
        log_error "릴리즈 빌드 실패!"
        return 1
    fi
}

# 함수: 앱 설치
install_app() {
    log_info "앱을 실제 기기에 설치 중..."
    flutter install -d "00008120-0011096C1A53C01E"
    if [ $? -eq 0 ]; then
        log_success "앱 설치 완료!"
        log_warning "앱을 실행하려면 iPhone에서 개발자 앱을 신뢰해야 합니다."
        log_info "설정 > 일반 > VPN 및 기기 관리에서 Apple Development 프로필을 신뢰하세요."
    else
        log_error "앱 설치 실패!"
        return 1
    fi
}

# 함수: Xcode 열기
open_xcode() {
    log_info "Xcode 프로젝트 열기..."
    open ios/Runner.xcworkspace
}

# 함수: 메뉴 표시
show_menu() {
    echo "=========================================="
    echo "    iOS Flutter 앱 빌드 & 실행 도구"
    echo "=========================================="
    echo ""
    echo "1. 연결된 기기 확인"
    echo "2. iOS 시뮬레이터에서 실행"
    echo "3. 실제 기기에서 디버그 모드 실행"
    echo "4. 실제 기기에서 릴리즈 모드 실행"
    echo "5. 릴리즈 빌드 생성"
    echo "6. 앱 설치"
    echo "7. Xcode 프로젝트 열기"
    echo "8. 전체 과정 자동 실행 (빌드 → 설치 → 실행)"
    echo "9. 종료"
    echo ""
    echo -n "선택하세요 (1-9): "
}

# 함수: 전체 과정 자동 실행
auto_process() {
    log_info "전체 과정 자동 실행 시작..."
    
    # 1. 릴리즈 빌드
    build_release
    if [ $? -ne 0 ]; then
        log_error "빌드 실패로 중단됩니다."
        return 1
    fi
    
    # 2. 앱 설치
    install_app
    if [ $? -ne 0 ]; then
        log_error "설치 실패로 중단됩니다."
        return 1
    fi
    
    # 3. Xcode 열기
    open_xcode
    
    log_success "전체 과정 완료!"
    log_info "Xcode에서 앱을 실행하거나 iPhone에서 직접 앱을 실행하세요."
}

# 메인 스크립트
main() {
    # Flutter 프로젝트 확인
    if [ ! -f "pubspec.yaml" ]; then
        log_error "Flutter 프로젝트가 아닙니다. 프로젝트 루트 디렉토리에서 실행하세요."
        exit 1
    fi
    
    # Flutter doctor 확인
    log_info "Flutter 환경 확인 중..."
    flutter doctor --android-licenses > /dev/null 2>&1
    
    while true; do
        show_menu
        read -r choice
        
        case $choice in
            1)
                check_devices
                ;;
            2)
                run_simulator
                ;;
            3)
                run_device_debug
                ;;
            4)
                run_device_release
                ;;
            5)
                build_release
                ;;
            6)
                install_app
                ;;
            7)
                open_xcode
                ;;
            8)
                auto_process
                ;;
            9)
                log_info "프로그램을 종료합니다."
                exit 0
                ;;
            *)
                log_error "잘못된 선택입니다. 1-9 중에서 선택하세요."
                ;;
        esac
        
        echo ""
        echo -n "계속하려면 Enter를 누르세요..."
        read -r
        clear
    done
}

# 스크립트 실행
main
