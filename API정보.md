# Drive Mate API 전체 엔드포인트 목록

## 📋 목차
1. [Authentication APIs](#authentication-apis)
2. [Car Management APIs](#car-management-apis)
3. [Car Control APIs](#car-control-apis)
4. [Climate Control APIs](#climate-control-apis)
5. [Car Utility APIs](#car-utility-apis)

---

## 🔐 Authentication APIs

### 1. 회원가입 (Sign-up)
**Endpoint**: `POST /api/authenticate/signup`
**인증 필요**: ❌

**요청 (Form Data)**:
```
mberId: string (필수, 4자 이상, 공백 불가)
mberPassword: string (필수, 4자 이상)
mberNm: string (필수)
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "회원가입이 완료되었습니다.",
  "data": {
    "token": "eyJhbGc...",
    "mberId": "user01",
    "mberNm": "홍길동"
  }
}
```

---

### 2. 로그인 (Sign-in)
**Endpoint**: `POST /api/authenticate/signin`
**인증 필요**: ❌

**요청 (Form Data)**:
```
mberId: string
mberPassword: string
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "로그인 성공",
  "data": {
    "token": "eyJhbGc...",
    "mberId": "user01",
    "mberNm": "홍길동"
  }
}
```

---

### 3. 로그아웃 (Sign-out)
**Endpoint**: `GET /api/authenticate/signout`
**인증 필요**: ✅

**헤더**:
```
Authorization: Bearer {token}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "로그아웃되었습니다.",
  "data": {
    "token": "new_token..."
  }
}
```

---

## 🚗 Car Management APIs

### 4. 차량 등록 (이미지 업로드)
**Endpoint**: `POST /api/car`
**인증 필요**: ✅

**요청 (Multipart Form Data)**:
```
carNm: string (차량 이름)
carNo: string (차량 번호)
file: File (이미지 파일, optional)
```

**헤더**:
```
Authorization: Bearer {token}
Content-Type: multipart/form-data
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "차량이 등록되었습니다.",
  "data": {
    "carId": "862BD8845A194C74921F690BCEE2D792",
    "carNm": "GV80",
    "carNo": "190허 1400",
    "carImage": "/static/uploads/uuid.jpg"
  }
}
```

---

### 5. 차량 등록 (이미지 업로드 불가)
**Endpoint**: `POST /api/car-noupload`
**인증 필요**: ✅

**요청 (Multipart Form Data)**:
```
carNm: string (차량 이름)
carNo: string (차량 번호)
```

**헤더**:
```
Authorization: Bearer {token}
Content-Type: multipart/form-data
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "차량이 등록되었습니다.",
  "data": {
    "carId": "A1B2C3D4E5F6...",
    "carNm": "GV80",
    "carNo": "190허 1400",
    "carImage": "/static/images/profile/genesis-kr-gv80-facelift-color-glossy-uyuni-white-large.png"
  }
}
```

**📝 자동 이미지 매핑**:
- GV80 → genesis-kr-gv80-facelift-color-glossy-uyuni-white-large.png
- G90 → genesis-kr-g90-spec-image-car-large.png
- GV70 → genesis-kr-electrified-gv70-colors-glossy-capri-blue-large.png
- G80 → genesis-kr-g80-facelift-sport-color-glossy-savile-silver-large.png
- i8 → i8.png
- Q7 → q7.png
- A8 → a8.png

---

### 6. 차량 목록 조회
**Endpoint**: `GET /api/car`
**인증 필요**: ✅

**헤더**:
```
Authorization: Bearer {token}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "차량 목록 조회 성공",
  "data": [
    {
      "carId": "862BD8845A194C74921F690BCEE2D792",
      "carNm": "GV80",
      "carNo": "190허 1400",
      "carImage": "/static/images/profile/...",
      "temperature": "18 °C",
      "weather": "rainy_snow",
      "location": "경상북도 영천시"
    }
  ]
}
```

---

### 7. 차량 단일 조회
**Endpoint**: `GET /api/car/{car_id}`
**인증 필요**: ✅

**Query Parameters**:
- `detailYn`: "Y" (상세 정보 포함) 또는 "N" (기본 정보만)

**헤더**:
```
Authorization: Bearer {token}
```

**응답 (detailYn=N)**:
```json
{
  "STATUS_CD": "S",
  "message": "차량 조회 성공",
  "data": {
    "carId": "862BD8845A194C74921F690BCEE2D792",
    "carNm": "GV80",
    "carNo": "190허 1400",
    "carImage": "/static/images/profile/...",
    "temperature": "18 °C",
    "weather": "rainy_snow",
    "location": "경상북도 영천시"
  }
}
```

**응답 (detailYn=Y)**:
```json
{
  "STATUS_CD": "S",
  "message": "차량 조회 성공",
  "data": {
    "carId": "862BD8845A194C74921F690BCEE2D792",
    "carNm": "GV80",
    "carNo": "190허 1400",
    "carImage": "/static/images/profile/...",
    "temperature": "18 °C",
    "weather": "rainy_snow",
    "location": "경상북도 영천시",
    "strtgYn": "N",
    "doorYn": "N",
    "wndwYn": "N",
    "emgncLmpYn": "N",
    "drvngPosblDstnc": 100,
    "tailgateYn": "N",
    "hoodYn": "N",
    "cdysmYn": "N",
    "handleYn": "N",
    "frontmirrorYn": "N",
    "backmirrorHeatYn": "N",
    "sidemirrorHeatYn": "N"
  }
}
```

---

### 8. 차량 삭제
**Endpoint**: `DELETE /api/car/{car_id}`
**인증 필요**: ✅

**헤더**:
```
Authorization: Bearer {token}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "차량이 삭제되었습니다.",
  "data": {
    "carId": "862BD8845A194C74921F690BCEE2D792"
  }
}
```

---

## 🎮 Car Control APIs

### 9. 시동 켜기/끄기
**Endpoint**: `PUT /api/car/{car_id}/strtg`
**인증 필요**: ✅

**헤더**:
```
Authorization: Bearer {token}
Content-Type: application/json
```

**요청 Body**:
```json
{
  "strtgYn": "Y"  // "Y": 켜기, "N": 끄기
}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "시동이 켜졌습니다.",
  "data": {
    "strtgYn": "Y"
  }
}
```

---

### 10. 도어 열기/닫기
**Endpoint**: `PUT /api/car/{car_id}/door`
**인증 필요**: ✅

**요청 Body**:
```json
{
  "doorYn": "Y"  // "Y": 열기, "N": 닫기
}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "도어가 열렸습니다.",
  "data": {
    "doorYn": "Y"
  }
}
```

---

### 11. 창문 열기/닫기
**Endpoint**: `PUT /api/car/{car_id}/wndw`
**인증 필요**: ✅

**요청 Body**:
```json
{
  "wndwYn": "Y"  // "Y": 열기, "N": 닫기
}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "창문이 열렸습니다.",
  "data": {
    "wndwYn": "Y"
  }
}
```

---

### 12. 비상등 켜기/끄기
**Endpoint**: `PUT /api/car/{car_id}/emgncLmp`
**인증 필요**: ✅

**요청 Body**:
```json
{
  "emgncLmpYn": "Y"  // "Y": 켜기, "N": 끄기
}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "비상등이 켜졌습니다.",
  "data": {
    "emgncLmpYn": "Y"
  }
}
```

---

### 13. 테일게이트 열기/닫기
**Endpoint**: `PUT /api/car/{car_id}/tailgate`
**인증 필요**: ✅

**요청 Body**:
```json
{
  "tailgateYn": "Y"  // "Y": 열기, "N": 닫기
}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "테일게이트가 열렸습니다.",
  "data": {
    "tailgateYn": "Y"
  }
}
```

---

### 14. 후드 열기/닫기
**Endpoint**: `PUT /api/car/{car_id}/hood`
**인증 필요**: ✅

**요청 Body**:
```json
{
  "hoodYn": "Y"  // "Y": 열기, "N": 닫기
}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "후드가 열렸습니다.",
  "data": {
    "hoodYn": "Y"
  }
}
```

---

## 🌡️ Climate Control APIs

### 15. 냉/난방 켜기/끄기
**Endpoint**: `PUT /api/car/{car_id}/cdysm`
**인증 필요**: ✅

**헤더**:
```
Authorization: Bearer {token}
Content-Type: application/json
```

**요청 Body**:
```json
{
  "cdysmYn": "Y"  // "Y": 켜기, "N": 끄기
}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "냉/난방이 켜졌습니다.",
  "data": {
    "cdysmYn": "Y"
  }
}
```

---

### 16. 핸들 열선 켜기/끄기
**Endpoint**: `PUT /api/car/{car_id}/handle`
**인증 필요**: ✅

**요청 Body**:
```json
{
  "handleYn": "Y"  // "Y": 켜기, "N": 끄기
}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "핸들 열선이 켜졌습니다.",
  "data": {
    "handleYn": "Y"
  }
}
```

---

### 17. 앞유리 성에 제거 켜기/끄기
**Endpoint**: `PUT /api/car/{car_id}/frontmirror`
**인증 필요**: ✅

**요청 Body**:
```json
{
  "frontmirrorYn": "Y"  // "Y": 켜기, "N": 끄기
}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "앞유리 성에 제거가 켜졌습니다.",
  "data": {
    "frontmirrorYn": "Y"
  }
}
```

---

### 18. 뒷유리 열선 켜기/끄기
**Endpoint**: `PUT /api/car/{car_id}/backmirrorHeat`
**인증 필요**: ✅

**요청 Body**:
```json
{
  "backmirrorHeatYn": "Y"  // "Y": 켜기, "N": 끄기
}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "뒷유리 열선이 켜졌습니다.",
  "data": {
    "backmirrorHeatYn": "Y"
  }
}
```

---

### 19. 사이드미러 열선 켜기/끄기
**Endpoint**: `PUT /api/car/{car_id}/sidemirrorHeat`
**인증 필요**: ✅

**요청 Body**:
```json
{
  "sidemirrorHeatYn": "Y"  // "Y": 켜기, "N": 끄기
}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "사이드미러 열선이 켜졌습니다.",
  "data": {
    "sidemirrorHeatYn": "Y"
  }
}
```

---

## 🛠️ Car Utility APIs

### 20. 주행 가능 거리 조정
**Endpoint**: `PUT /api/car/{car_id}/drvngPosblDstnc`
**인증 필요**: ✅

**헤더**:
```
Authorization: Bearer {token}
Content-Type: application/json
```

**요청 Body**:
```json
{
  "drvngPosblDstnc": 250  // 정수형 (km)
}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "주행 가능 거리가 조정되었습니다.",
  "data": {
    "drvngPosblDstnc": 250
  }
}
```

---

### 21. 차량 상태 일괄 수정
**Endpoint**: `PUT /api/car/{car_id}`
**인증 필요**: ✅

**헤더**:
```
Authorization: Bearer {token}
Content-Type: application/json
```

**요청 Body**:
```json
{
  "strtgYn": "Y",
  "doorYn": "Y",
  "wndwYn": "N",
  "emgncLmpYn": "Y",
  "drvngPosblDstnc": 500,
  "tailgateYn": "Y",
  "hoodYn": "N",
  "cdysmYn": "Y",
  "handleYn": "Y",
  "frontmirrorYn": "N",
  "backmirrorHeatYn": "Y",
  "sidemirrorHeatYn": "Y"
}
```

**응답**:
```json
{
  "STATUS_CD": "S",
  "message": "차량 상태가 일괄 수정되었습니다.",
  "data": {
    "strtgYn": "Y",
    "doorYn": "Y",
    "wndwYn": "N",
    "emgncLmpYn": "Y",
    "drvngPosblDstnc": 500,
    "tailgateYn": "Y",
    "hoodYn": "N",
    "cdysmYn": "Y",
    "handleYn": "Y",
    "frontmirrorYn": "N",
    "backmirrorHeatYn": "Y",
    "sidemirrorHeatYn": "Y"
  }
}
```

---

## 📊 데이터 타입 명세

### 차량 상태 필드
| 필드명 | 타입 | 설명 | 값 범위 |
|--------|------|------|---------|
| strtgYn | String(1) | 시동 상태 | "Y" 또는 "N" |
| doorYn | String(1) | 도어 상태 | "Y" 또는 "N" |
| wndwYn | String(1) | 창문 상태 | "Y" 또는 "N" |
| emgncLmpYn | String(1) | 비상등 상태 | "Y" 또는 "N" |
| tailgateYn | String(1) | 테일게이트 상태 | "Y" 또는 "N" |
| hoodYn | String(1) | 후드 상태 | "Y" 또는 "N" |

### 공조 상태 필드
| 필드명 | 타입 | 설명 | 값 범위 |
|--------|------|------|---------|
| cdysmYn | String(1) | 냉/난방 상태 | "Y" 또는 "N" |
| handleYn | String(1) | 핸들 열선 상태 | "Y" 또는 "N" |
| frontmirrorYn | String(1) | 앞유리 성에 제거 상태 | "Y" 또는 "N" |
| backmirrorHeatYn | String(1) | 뒷유리 열선 상태 | "Y" 또는 "N" |
| sidemirrorHeatYn | String(1) | 사이드미러 열선 상태 | "Y" 또는 "N" |

### 기타 필드
| 필드명 | 타입 | 설명 | 예시 |
|--------|------|------|------|
| drvngPosblDstnc | Integer | 주행 가능 거리 (km) | 100 |
| temperature | Float | 온도 (섭씨) | 18.0 |
| weather | String | 날씨 코드 | "rainy_snow" |
| location | String | 위치 | "경상북도 영천시" |
| carImage | String | 이미지 경로 | "/static/images/..." |
| created_at | DateTime | 생성 일시 | "2025-01-01 10:00:00" |

### 날씨 코드
| 코드 | 설명 |
|------|------|
| sunny | 맑음 ☀️ |
| cloud | 구름 ☁️ |
| cloudy_snowing | 흐림+눈 🌨️ |
| rainy | 비 🌧️ |
| rainy_snow | 비+눈 🌨️ |
| thunderstorm | 천둥번개 ⛈️ |

---

## ⚠️ 오류 코드

| STATUS_CD | 설명 |
|-----------|------|
| S | 성공 |
| E001 | 일반 오류 |
| E002 | 유효성 검사 실패 (회원가입) |
| E003 | 인증 실패 (로그인) |
| E004 | 차량을 찾을 수 없음 |
| E999 | 서버 내부 오류 |

---

## 🔒 인증 방식

모든 인증이 필요한 API는 HTTP Header에 Bearer Token을 포함해야 합니다:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

토큰은 로그인 또는 회원가입 시 발급됩니다.

---

## 📝 참고사항

1. **HTTP Status Code**
   - 성공: 200 OK
   - 오류: 400 Bad Request
   - 인증 실패: 401 Unauthorized

2. **Content-Type**
   - Form 데이터: `application/x-www-form-urlencoded` 또는 `multipart/form-data`
   - JSON 데이터: `application/json`

3. **이미지 경로**
   - 문자열 형태로 저장
   - 실제 파일 경로: `/static/images/profile/...`
   - 업로드 파일 경로: `/static/uploads/...`

4. **데이터베이스**
   - SQLite 사용
   - 외래키 제약조건 적용
   - 자동 타임스탬프 (created_at)
