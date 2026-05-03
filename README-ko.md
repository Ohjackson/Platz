# Platz - 독일어 및 독일 문화 학습 앱

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2017.0%2B-blue.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)

**Platz**는 한국어 사용자를 위한 종합 독일어 및 독일 문화 학습 iOS 앱입니다. 체계적인 언어 학습 레슨, 상호작용 대화 연습, 퀴즈, 그리고 독일에 관한 심층 아티클을 제공합니다.

---

## 📱 주요 기능

### 1. **학습 섹션** - 독일어 언어 학습
4개의 트랙으로 구성된 핵심 언어 학습 모듈:

#### 학습 트랙
- **알파벳 트랙** (`alphabet`) - 독일어 알파벳 및 특수문자 (Ä, Ö, Ü, ß)
- **숫자 트랙** (`numbers`) - 1부터 1000 이상, 독일어 특유의 숫자 규칙 포함
- **문법 트랙** (`grammar`) - 필수 독일어 문법 (관사, 동사 활용)
- **회화 트랙** (`conversation`) - 일상 표현 및 회화
- **A1/A2 레벨 선택** - 선택한 CEFR 레벨에 맞춰 레슨과 회화 목록 필터링

#### 인터랙티브 기능
- **레슨 상세 뷰** - 예시, 팁, 발음 가이드가 포함된 마크다운 기반 레슨 콘텐츠
- **대화 연습** (`DialogView`) - 화자별 실제 대화 시나리오
- **미니 퀴즈** (`QuizView`) - 각 레슨과 연결된 객관식 퀴즈
- **진행 상황 추적** - 자동 완료 추적 및 통계
- **음성 합성** - 독일어 발음 연습을 위한 TTS 기능

#### 데이터 소스
- `lessons.json` - A1/A2에 걸친 22개 구조화된 레슨
- `dialogs.json` - A1/A2에 걸친 13개 회화 시나리오
- `quizzes.json` - 설명이 포함된 25개 퀴즈
- `quotes.json` - 번역 및 설명이 있는 독일어 명언

---

### 2. **독일 섹션** - 문화 지식
독일의 문화, 정치, 행정, 생활에 관한 종합 아티클:

#### 아티클 카테고리
- **일반** (`general`) - 지리, 교육 시스템, 기후
- **정치** (`politics`) - 정치 구조, 정당, 선거 제도  
- **행정** (`admin`) - 거주지 등록(Anmeldung), 건강보험, 은행 계좌
- **문화** (`culture`) - 음식, 크리스마스 전통, 축구 문화

#### 기능
- 마크다운을 지원하는 **아티클 상세 뷰**
- 핵심 정보를 위한 **빠른 정보** 박스
- **관련 아티클** 추천
- **카테고리별 탐색** 및 **인기 아티클** 섹션
- **검색 기능** (계획 중)

#### 데이터 소스
- `articles.json` - 독일 생활의 다양한 측면을 다루는 12개의 심층 아티클

---

### 3. **홈 섹션** - 대시보드
- **오늘의 명언** - 번역이 포함된 랜덤 독일어 동기부여 명언
- **학습 이어하기** - 마지막 레슨 재개
- **진행 상황 개요** - 완료한 레슨, 연속 학습일, 총 학습 시간
- **빠른 접근** - 트랙 및 추천 콘텐츠로의 직접 링크

---

### 4. **설정 섹션**
- 사용자 프로필 커스터마이징
- 학습 설정
- 데이터 관리
- 앱 정보

---

## 🏗️ 아키텍처

### 기술 스택
- **프레임워크**: SwiftUI
- **최소 iOS 버전**: 17.0
- **언어**: Swift 5.9
- **데이터 저장**: JSON 파일 + 진행 상황은 UserDefaults
- **음성**: AVFoundation (AVSpeechSynthesizer)

### 프로젝트 구조

```
Platz/
├── Models/
│   ├── Article.swift      # 독일 섹션 아티클
│   ├── Lesson.swift       # 언어 학습 레슨
│   ├── Dialog.swift       # 회화 연습
│   ├── Quiz.swift         # 퀴즈 문제 및 답변
│   ├── Quote.swift        # 일일 동기부여 명언
│   └── Progress.swift     # 사용자 진행 상황 추적
│
├── Data/
│   ├── articles.json      # 독일에 관한 12개 아티클
│   ├── lessons.json       # 22개 언어 학습 레슨
│   ├── dialogs.json       # 13개 회화 시나리오
│   ├── quizzes.json       # 25개 퀴즈 세트
│   └── quotes.json        # 10개 독일어 명언
│
├── Utilities/
│   ├── DataManager.swift  # JSON 데이터 로딩 및 캐싱
│   └── SpeechManager.swift # TTS 기능
│
├── Components/
│   ├── PlatzCard.swift     # 재사용 가능한 카드 컴포넌트
│   ├── QuickFactsBox.swift # 아티클 정보 박스
│   └── Theme.swift         # 앱 전역 테마
│
├── Views/
│   ├── Main/
│   │   ├── MainTabView.swift  # 탭 바 컨테이너
│   │   └── HomeView.swift     # 대시보드/홈 화면
│   │
│   ├── Learn/
│   │   ├── LearnView.swift         # 트랙 선택
│   │   ├── TrackDetailView.swift   # 트랙별 레슨 목록
│   │   ├── LessonDetailView.swift  # 레슨 콘텐츠
│   │   ├── DialogView.swift        # 대화 연습
│   │   └── QuizView.swift          # 퀴즈 인터페이스
│   │
│   ├── Germany/
│   │   ├── GermanyView.swift       # 아티클 카테고리
│   │   └── ArticleDetailView.swift # 아티클 읽기
│   │
│   ├── Settings/
│   │   └── SettingsView.swift      # 앱 설정
│   │
│   └── Onboarding/
│       └── OnboardingView.swift    # 첫 실행 튜토리얼
│
└── Assets.xcassets/
    ├── AppIcon.appiconset/
    └── bedge.imageset/
```

---

## 📊 데이터 구조 상세

### Lessons (`lessons.json`)
**`LearnView`(트랙 선택), `TrackDetailView`(레슨 목록), `LessonDetailView`(레슨 내용)에서 사용**

각 레슨은 다음을 포함:
- `id`, `track`, `title`, `level`, `durationMin`, `order`
- `contentMarkdown` - 마크다운 형식의 메인 레슨 콘텐츠
- `examples[]` - 독일어, 한국어, 발음, 노트가 포함된 예시
- `tips[]` - 학습 팁
- `miniQuizId` - 연결된 퀴즈 참조

**구성**: 22개 레슨
- A1 레슨 16개: 알파벳, 숫자, 기초 문법, 기초 회화
- A2 레슨 6개: Perfekt, 조동사, 부문장, 분리동사, 약속 변경, 도움 요청

---

### Dialogs (`dialogs.json`)
**`DialogView`(대화 연습)와 `LearnView`(대화 섹션)에서 사용**

회화 시나리오:
- `topic`, `title`, `description`, `level`, `order`
- `lines[]` - 화자, 독일어 텍스트, 한국어 번역, 노트가 포함된 대화 차례 배열
- `keywords[]` - 의미가 포함된 핵심 어휘
- `quizId` - 선택적 연결 퀴즈

**구성**: 13개 대화
- A1 대화 10개: 인사, 카페, 길찾기, 쇼핑, 호텔, 여행, 학교, 취미, 기차표 등
- A2 대화 3개: 약속 시간 변경, 병원 예약, 집 문제 설명

---

### Quizzes (`quizzes.json`)
**`QuizView`(퀴즈 화면), `LessonDetailView`(레슨 퀴즈), `DialogView`(대화 퀴즈)에서 사용**

퀴즈 데이터 구조:
- `type` - "lesson" 또는 "dialog"
- `sourceLessonId` / `sourceDialogId` - 상위 콘텐츠 참조
- `passingScore` - 필요 점수 (일반적으로 60%)
- `questions[]` - 객관식 문제:
  - `question`, `options[]`, `correctAnswer`, `explanation`

**구성**: 25개 퀴즈
- 알파벳 퀴즈 3개
- 숫자 퀴즈 3개
- 문법 퀴즈 11개
- 회화 퀴즈 5개
- 대화 퀴즈 3개

---

### Articles (`articles.json`)
**`GermanyView`(아티클 목록 및 카테고리), `ArticleDetailView`(아티클 읽기)에서 사용**

종합 아티클:
- `category` - general, politics, admin, culture
- `title`, `summary`, `readTime`
- `sections[]` - `heading`과 `bodyMarkdown`이 있는 배열
- `quickFacts[]` - 빠른 참조를 위한 키-값 쌍
- `relatedIds[]` - 관련 아티클 ID
- `tags[]` - 분류 태그

**구성**: 카테고리별 12개 아티클
- **일반** (3개): 독일 개요, 교육 시스템, 지리와 기후
- **정치** (3개): 정치 구조, 주요 정당, 선거 제도
- **행정** (3개): 거주지 등록, 건강보험, 은행 계좌
- **문화** (3개): 식문화, 크리스마스 문화, 축구 문화

---

### Quotes (`quotes.json`)
**`HomeView`(랜덤 일일 명언)에서 사용**

동기부여 명언:
- `de` - 독일어 텍스트
- `ko` - 한국어 번역
- `author` - 출처 (선택)
- `explain` - 상세 설명
- `level` - beginner/intermediate
- `tags[]` - 주제 태그

**구성**: 10개 명언
- 초급 레벨 9개
- 중급 레벨 1개
- 주제: 동기부여, 용기, 연습, 인내, 호기심, 단순함

---

## 🚀 시작하기

### 요구사항
- Xcode 15.0 이상
- macOS 14.0 이상 (Sonoma)
- iOS 17.0 이상 기기 또는 시뮬레이터

### 설치

1. 레포지토리 클론:
```bash
git clone <repository-url>
cd Platz
```

2. 프로젝트 열기:
```bash
open Platz.xcodeproj
```

3. 빌드 및 실행:
- 대상 기기/시뮬레이터 선택
- `Cmd + R`을 눌러 빌드 및 실행

### 프로젝트 구성
- **Bundle Identifier**: 프로젝트 설정에서 지정
- **Deployment Target**: iOS 17.0
- **지원 기기**: iPhone (세로 방향)

---

## 💾 데이터 관리

### DataManager
`DataManager` 싱글톤이 처리하는 것:
- JSON 파일 로딩 및 파싱
- 성능을 위한 데이터 캐싱
- 우아한 폴백을 통한 에러 처리

### 진행 상황 추적
사용자 진행 상황은 다음을 사용하여 저장:
- **UserDefaults** - 레슨 완료 상태
- **@AppStorage** - 반응형 UI 업데이트
- Progress 모델이 추적: 완료한 레슨, 연속 학습일, 학습 시간

### 음성 합성
`SpeechManager` 제공 기능:
- AVSpeechSynthesizer를 통한 독일어 TTS
- 음성 설정 (de-DE 로케일)
- 재생 제어 (재생, 일시정지, 정지)

---
