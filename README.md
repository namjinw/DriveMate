# Drive Mate API

제5회 민간기능경기대회 Drive Mate 프로젝트용 백엔드 API

## 주요 개선사항

### 1. 적절한 데이터 타입 적용
- **온도**: `Float` 타입 사용 (예: 18.0°C)
- **주행 가능 거리**: `Integer` 타입 사용 (예: 100km)
- **날짜/시간**: `DateTime` 타입 사용
- **상태 값**: `String(1)` 타입 (Y/N)
- **이미지 경로**: `String` 타입 유지

### 2. 모든 API 엔드포인트 구현
- ✅ 인증 API (회원가입, 로그인, 로그아웃)
- ✅ 차량 기본 API (등록, 조회, 삭제)
- ✅ 차량 제어 API (시동, 도어, 창문, 비상등, 테일게이트, 후드)
- ✅ 공조 제어 API (냉난방, 핸들열선, 앞유리, 뒷유리, 사이드미러)
- ✅ 차량 유틸리티 API (거리 조정, 일괄 수정)

### 3. 풍부한 샘플 데이터 및 랜덤 생성
- 5명의 사용자 데이터
- 10대의 다양한 차량 데이터
- 다양한 날씨 정보 (sunny, cloud, rainy, rainy_snow, cloudy_snowing, thunderstorm)
- 다양한 위치 정보 (서울, 부산, 대구, 인천 등)
- **🎲 차량 등록 시 자동 랜덤 생성**:
  - 온도: 5°C ~ 30°C 범위에서 랜덤
  - 날씨: 6가지 타입 중 랜덤 선택
  - 위치: 25개 주요 도시 중 랜덤 선택
  - 주행거리: 40% 빨간색(5-49km), 30% 파란색(50-100km), 30% 정상(101-500km)

## 설치 및 실행

### 1. 패키지 설치
```bash
pip install -r requirements.txt --break-system-packages
```

### 2. 데이터베이스 초기화
```bash
python init_db.py
# 메뉴에서 1번 선택 -> y 입력
```

### 3. API 서버 실행
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### 4. API 문서 확인
브라우저에서 접속:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## API 엔드포인트

### Authentication (인증)
- `POST /api/authenticate/signup` - 회원가입
- `POST /api/authenticate/signin` - 로그인
- `GET /api/authenticate/signout` - 로그아웃

### Car (차량)
- `POST /api/car` - 차량 등록 (이미지 업로드)
- `POST /api/car-noupload` - 차량 등록 (이미지 없음)
- `GET /api/car` - 차량 목록 조회
- `GET /api/car/{car_id}` - 차량 단일 조회
- `DELETE /api/car/{car_id}` - 차량 삭제

### Car Control (차량 제어)
- `PUT /api/car/{car_id}/strtg` - 시동 켜기/끄기
- `PUT /api/car/{car_id}/door` - 도어 열기/닫기
- `PUT /api/car/{car_id}/wndw` - 창문 열기/닫기
- `PUT /api/car/{car_id}/emgncLmp` - 비상등 켜기/끄기
- `PUT /api/car/{car_id}/tailgate` - 테일게이트 열기/닫기
- `PUT /api/car/{car_id}/hood` - 후드 열기/닫기

### Climate Control (공조 제어)
- `PUT /api/car/{car_id}/cdysm` - 냉/난방 켜기/끄기
- `PUT /api/car/{car_id}/handle` - 핸들 열선 켜기/끄기
- `PUT /api/car/{car_id}/frontmirror` - 앞유리 성에 제거 켜기/끄기
- `PUT /api/car/{car_id}/backmirrorHeat` - 뒷유리 열선 켜기/끄기
- `PUT /api/car/{car_id}/sidemirrorHeat` - 사이드미러 열선 켜기/끄기

### Car Util (차량 유틸리티)
- `PUT /api/car/{car_id}/drvngPosblDstnc` - 주행 가능 거리 조정
- `PUT /api/car/{car_id}` - 차량 상태 일괄 수정

## 응답 형식

### 성공 응답
```json
{
  "STATUS_CD": "S",
  "message": "성공 메시지",
  "data": { /* 데이터 */ }
}
```

### 오류 응답
```json
{
  "STATUS_CD": "E001",
  "message": "오류 메시지"
}
```

## 테스트 계정

| 사용자 ID | 비밀번호 | 이름 |
|-----------|----------|------|
| user01    | 1234     | 홍길동 |
| user02    | 1234     | 김철수 |
| user03    | 1234     | 이영희 |
| testuser  | 1234     | 테스트사용자 |
| admin     | 1234     | 관리자 |

## 샘플 차량 데이터

각 사용자는 1~3대의 차량을 소유하고 있으며, 다음과 같은 다양한 정보를 포함합니다:
- 차량명: GV80, G90, GV70, G80 Sport, BMW i8, Audi Q7, Audi A8, Genesis G70, Tesla Model S
- 온도: 8.0°C ~ 25.0°C
- 날씨: sunny, cloud, rainy, rainy_snow, cloudy_snowing, thunderstorm
- 위치: 서울, 부산, 대구, 인천, 광주, 대전, 울산, 세종 등
- 주행 거리: 80km ~ 450km

## 날씨 아이콘 매핑

| 코드 | 설명 |
|------|------|
| sunny | 맑음 |
| cloud | 구름 |
| cloudy_snowing | 흐림+눈 |
| rainy | 비 |
| rainy_snow | 비+눈 |
| thunderstorm | 천둥번개 |

## 주의사항

1. **인증**: 대부분의 API는 Bearer Token 인증이 필요합니다
2. **HTTP 상태 코드**: 성공 시 200, 오류 시 400 반환
3. **STATUS_CD**: S는 성공, E로 시작하면 오류
4. **이미지 경로**: 문자열 형태로 저장 (예: `/static/images/profile/...`)

## 프로젝트 구조

```
drivemate_api/
├── main.py              # FastAPI 애플리케이션
├── models.py            # SQLAlchemy 모델
├── schemas.py           # Pydantic 스키마
├── database.py          # 데이터베이스 설정
├── init_db.py           # DB 초기화 스크립트
├── requirements.txt     # 의존성 패키지
└── drive_mate.db        # SQLite 데이터베이스 (실행 후 생성)
```

## 개발자 정보

- 프로젝트: 제5회 민간기능경기대회 Drive Mate
- API 버전: 1.0.0
- 데이터베이스: SQLite
- 프레임워크: FastAPI + SQLAlchemy