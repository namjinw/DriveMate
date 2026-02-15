from fastapi import FastAPI, Depends, HTTPException, Request, File, UploadFile, Form
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from sqlalchemy.orm import Session
from jose import jwt
from datetime import datetime, timedelta
from typing import Optional
import os
import uuid
import random

import models, schemas
from database import SessionLocal, engine, Base, get_db

# 테이블 생성
Base.metadata.create_all(bind=engine)

from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Drive Mate API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 파일 업로드 디렉토리 설정
UPLOAD_DIR = "static/uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)
app.mount("/static", StaticFiles(directory="static"), name="static")

# --- 설정 ---
SECRET_KEY = "SECRET_DRIVE_MATE_1234"
ALGORITHM = "HS256"


# --- 유틸리티 함수 ---
def create_token(user_id: str):
    """JWT 토큰 생성"""
    payload = {
        "userId": user_id,
        "exp": datetime.utcnow() + timedelta(hours=24)
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def get_current_user(request: Request, db: Session = Depends(get_db)):
    """현재 인증된 사용자 가져오기"""
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="UNAUTHORIZED")

    token = auth_header.split(" ")[1]
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = payload.get("userId")
        user = db.query(models.User).filter(models.User.mber_id == user_id).first()
        if not user:
            raise HTTPException(status_code=401, detail="UNAUTHORIZED")
        return user
    except:
        raise HTTPException(status_code=401, detail="UNAUTHORIZED")


def success_response(message: str = "성공", data=None, status_cd: str = "S"):
    """성공 응답 생성"""
    return {
        "STATUS_CD": status_cd,
        "message": message,
        "data": data
    }


def error_response(message: str = "오류 발생", status_cd: str = "E001"):
    """오류 응답 생성"""
    return JSONResponse(
        status_code=400,
        content={
            "STATUS_CD": status_cd,
            "message": message
        }
    )


def format_temperature(temp: float) -> str:
    """온도를 문자열 형식으로 변환"""
    return f"{int(temp)} °C"


def generate_random_car_data():
    """차량 등록 시 랜덤 데이터 생성"""
    # 온도: 5°C ~ 30°C
    temperature = round(random.uniform(5.0, 30.0), 1)

    # 날씨 목록
    weather_list = ["sunny", "cloud", "cloudy_snowing", "rainy", "rainy_snow", "thunderstorm"]
    weather = random.choice(weather_list)

    # 위치 목록
    locations = [
        "서울특별시 강남구",
        "서울특별시 종로구",
        "부산광역시 해운대구",
        "부산광역시 수영구",
        "대구광역시 수성구",
        "대구광역시 중구",
        "인천광역시 연수구",
        "인천광역시 남동구",
        "광주광역시 서구",
        "광주광역시 북구",
        "대전광역시 유성구",
        "대전광역시 서구",
        "울산광역시 남구",
        "울산광역시 중구",
        "세종특별자치시",
        "경기도 성남시",
        "경기도 수원시",
        "경기도 고양시",
        "경상북도 영천시",
        "경상북도 포항시",
        "경상남도 창원시",
        "전라북도 전주시",
        "전라남도 여수시",
        "충청북도 청주시",
        "충청남도 천안시"
    ]
    location = random.choice(locations)

    # 주행 가능 거리: 다양한 범위로 생성
    # 40% - 50km 미만 (빨간색)
    # 30% - 50-100km (파란색)
    # 30% - 100km 이상 (정상)
    rand = random.random()
    if rand < 0.4:
        # 50km 미만
        distance = random.randint(5, 49)
    elif rand < 0.7:
        # 50-100km
        distance = random.randint(50, 100)
    else:
        # 100km 이상
        distance = random.randint(101, 500)

    return {
        "temperature": temperature,
        "weather": weather,
        "location": location,
        "drvng_posbl_dstnc": distance
    }


# --- Authentication API ---

@app.post("/api/authenticate/signup", tags=["Authentication"])
def signup(
        mberId: str = Form(...),
        mberPassword: str = Form(...),
        mberNm: str = Form(...)
):
    """
    회원가입 API
    - 아이디 중복 체크
    - 사용자 생성 및 토큰 발급
    """
    db = SessionLocal()
    try:
        # 유효성 검사
        if len(mberId) < 4:
            return error_response("아이디는 4자 이상이어야 합니다.", "E002")
        if len(mberPassword) < 4:
            return error_response("비밀번호는 4자 이상이어야 합니다.", "E002")
        if " " in mberId:
            return error_response("아이디에 공백을 포함할 수 없습니다.", "E002")

        # 중복 체크
        existing = db.query(models.User).filter(models.User.mber_id == mberId).first()
        if existing:
            return error_response("이미 존재하는 아이디입니다.", "E002")

        # 사용자 생성
        new_user = models.User(
            mber_id=mberId,
            mber_password=mberPassword,
            mber_nm=mberNm
        )
        db.add(new_user)
        db.commit()
        db.refresh(new_user)

        # 토큰 생성
        token = create_token(new_user.mber_id)

        return success_response(
            "회원가입이 완료되었습니다.",
            {"token": token, "mberId": mberId, "mberNm": mberNm}
        )
    except Exception as e:
        return error_response(f"회원가입 중 오류가 발생했습니다: {str(e)}", "E999")
    finally:
        db.close()


@app.post("/api/authenticate/signin", tags=["Authentication"])
def signin(
        mberId: str = Form(...),
        mberPassword: str = Form(...)
):
    """
    로그인 API
    - 아이디/비밀번호 검증
    - 토큰 발급
    """
    db = SessionLocal()
    try:
        user = db.query(models.User).filter(
            models.User.mber_id == mberId,
            models.User.mber_password == mberPassword
        ).first()

        if not user:
            return error_response("아이디 또는 비밀번호가 올바르지 않습니다.", "E003")

        # 토큰 생성
        token = create_token(user.mber_id)

        return success_response(
            "로그인 성공",
            {"token": token, "mberId": user.mber_id, "mberNm": user.mber_nm}
        )
    except Exception as e:
        return error_response(f"로그인 중 오류가 발생했습니다: {str(e)}", "E999")
    finally:
        db.close()


@app.get("/api/authenticate/signout", tags=["Authentication"])
def signout(user: models.User = Depends(get_current_user)):
    """
    로그아웃 API
    - 새로운 토큰 발급 (기존 토큰 무효화)
    """
    # 로그아웃 시 새로운 토큰 발급 (기존 토큰 무효화 개념)
    new_token = create_token(user.mber_id)
    return success_response(
        "로그아웃되었습니다.",
        {"token": new_token}
    )


# --- Car API ---

@app.post("/api/car", tags=["Car"])
async def register_car_with_image(
        carNm: str = Form(...),
        carNo: str = Form(...),
        file: Optional[UploadFile] = File(None),
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """
    자동차 등록 API (이미지 업로드 지원)
    - 이미지 파일 업로드
    - 차량 정보 저장
    - 온도, 날씨, 위치, 주행거리는 랜덤 생성
    """
    try:
        # 파일 저장
        car_image_url = None
        if file:
            file_ext = os.path.splitext(file.filename)[1]
            filename = f"{uuid.uuid4()}{file_ext}"
            filepath = os.path.join(UPLOAD_DIR, filename)

            with open(filepath, "wb") as f:
                content = await file.read()
                f.write(content)

            car_image_url = f"/static/uploads/{filename}"

        # 랜덤 차량 데이터 생성
        random_data = generate_random_car_data()

        # 차량 등록
        car_id = str(uuid.uuid4()).replace("-", "").upper()
        new_car = models.Car(
            car_id=car_id,
            user_id=user.id,
            car_nm=carNm,
            car_no=carNo,
            car_image=car_image_url,
            strtg_yn="N",
            door_yn="N",
            wndw_yn="N",
            emgnc_lmp_yn="N",
            drvng_posbl_dstnc=random_data["drvng_posbl_dstnc"],
            tailgate_yn="N",
            hood_yn="N",
            cdysm_yn="N",
            handle_yn="N",
            frontmirror_yn="N",
            backmirror_heat_yn="N",
            sidemirror_heat_yn="N",
            temperature=random_data["temperature"],
            weather=random_data["weather"],
            location=random_data["location"]
        )
        db.add(new_car)
        db.commit()
        db.refresh(new_car)

        return success_response(
            "차량이 등록되었습니다.",
            {
                "carId": car_id,
                "carNm": carNm,
                "carNo": carNo,
                "carImage": car_image_url
            }
        )
    except Exception as e:
        return error_response(f"차량 등록 중 오류가 발생했습니다: {str(e)}", "E999")


@app.post("/api/car-noupload", tags=["Car"])
def register_car_no_upload(
        carNm: str = Form(...),
        carNo: str = Form(...),
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """
    자동차 등록 API (이미지 업로드 불가 시)
    - 기본 이미지 자동 선택
    - 온도, 날씨, 위치, 주행거리는 랜덤 생성
    """
    try:
        car_id = str(uuid.uuid4()).replace("-", "").upper()

        # 차량 이름에 따라 기본 이미지 선택
        default_images = {
            "GV80": "/static/images/profile/genesis-kr-gv80-facelift-color-glossy-uyuni-white-large.png",
            "G90": "/static/images/profile/genesis-kr-g90-spec-image-car-large.png",
            "GV70": "/static/images/profile/genesis-kr-electrified-gv70-colors-glossy-capri-blue-large.png",
            "G80": "/static/images/profile/genesis-kr-g80-facelift-sport-color-glossy-savile-silver-large.png",
            "i8": "/static/images/profile/i8.png",
            "Q7": "/static/images/profile/q7.png",
            "A8": "/static/images/profile/a8.png"
        }

        # 차량 이름으로 기본 이미지 찾기 (부분 매칭)
        car_image = "/static/images/profile/genesis-kr-gv80-facelift-color-glossy-uyuni-white-large.png"  # 기본값
        for key, img_path in default_images.items():
            if key.lower() in carNm.lower():
                car_image = img_path
                break

        # 랜덤 차량 데이터 생성
        random_data = generate_random_car_data()

        new_car = models.Car(
            car_id=car_id,
            user_id=user.id,
            car_nm=carNm,
            car_no=carNo,
            car_image=car_image,
            strtg_yn="N",
            door_yn="N",
            wndw_yn="N",
            emgnc_lmp_yn="N",
            drvng_posbl_dstnc=random_data["drvng_posbl_dstnc"],
            tailgate_yn="N",
            hood_yn="N",
            cdysm_yn="N",
            handle_yn="N",
            frontmirror_yn="N",
            backmirror_heat_yn="N",
            sidemirror_heat_yn="N",
            temperature=random_data["temperature"],
            weather=random_data["weather"],
            location=random_data["location"]
        )
        db.add(new_car)
        db.commit()
        db.refresh(new_car)

        return success_response(
            "차량이 등록되었습니다.",
            {
                "carId": car_id,
                "carNm": carNm,
                "carNo": carNo,
                "carImage": car_image
            }
        )
    except Exception as e:
        return error_response(f"차량 등록 중 오류가 발생했습니다: {str(e)}", "E999")


@app.get("/api/car", tags=["Car"])
def get_car_list(
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """
    자동차 목록 조회 API
    - 사용자의 모든 차량 조회
    """
    try:
        cars = db.query(models.Car).filter(models.Car.user_id == user.id).all()

        car_list = []
        for car in cars:
            car_list.append({
                "carId": car.car_id,
                "carNm": car.car_nm,
                "carNo": car.car_no,
                "carImage": car.car_image,
                "temperature": format_temperature(car.temperature),
                "weather": car.weather,
                "location": car.location,
                "drvngPosblDstnc": car.drvng_posbl_dstnc
            })

        return success_response("차량 목록 조회 성공", car_list)
    except Exception as e:
        return error_response(f"차량 목록 조회 중 오류가 발생했습니다: {str(e)}", "E999")


@app.get("/api/car/{car_id}", tags=["Car"])
def get_car_detail(
        car_id: str,
        detailYn: Optional[str] = "N",
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """
    자동차 단일 조회 API
    - 차량 상세 정보 조회
    - detailYn=Y 시 모든 상태 정보 포함
    """
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        car_data = {
            "carId": car.car_id,
            "carNm": car.car_nm,
            "carNo": car.car_no,
            "carImage": car.car_image,
            "temperature": format_temperature(car.temperature),
            "weather": car.weather,
            "location": car.location,
            "drvngPosblDstnc": car.drvng_posbl_dstnc
        }

        if detailYn == "Y":
            car_data.update({
                "strtgYn": car.strtg_yn,
                "doorYn": car.door_yn,
                "wndwYn": car.wndw_yn,
                "emgncLmpYn": car.emgnc_lmp_yn,
                "tailgateYn": car.tailgate_yn,
                "hoodYn": car.hood_yn,
                "cdysmYn": car.cdysm_yn,
                "handleYn": car.handle_yn,
                "frontmirrorYn": car.frontmirror_yn,
                "backmirrorHeatYn": car.backmirror_heat_yn,
                "sidemirrorHeatYn": car.sidemirror_heat_yn
            })

        return success_response("차량 조회 성공", car_data)
    except Exception as e:
        return error_response(f"차량 조회 중 오류가 발생했습니다: {str(e)}", "E999")


@app.put("/api/car/{car_id}/strtg", tags=["Car Control"])
def control_strtg(
        car_id: str,
        req: schemas.StrtgControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """자동차 시동 켜기/끄기"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        car.strtg_yn = req.strtgYn
        db.commit()

        action = "켜졌습니다" if req.strtgYn == "Y" else "꺼졌습니다"
        return success_response(
            f"시동이 {action}.",
            {"strtgYn": car.strtg_yn}
        )
    except Exception as e:
        return error_response(f"시동 제어 중 오류가 발생했습니다: {str(e)}", "E999")


@app.put("/api/car/{car_id}/door", tags=["Car Control"])
def control_door(
        car_id: str,
        req: schemas.DoorControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """자동차 문 열기/닫기"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        car.door_yn = req.doorYn
        db.commit()

        action = "열렸습니다" if req.doorYn == "Y" else "닫혔습니다"
        return success_response(
            f"도어가 {action}.",
            {"doorYn": car.door_yn}
        )
    except Exception as e:
        return error_response(f"도어 제어 중 오류가 발생했습니다: {str(e)}", "E999")


@app.put("/api/car/{car_id}/wndw", tags=["Car Control"])
def control_wndw(
        car_id: str,
        req: schemas.WndwControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """자동차 창문 열기/닫기"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        car.wndw_yn = req.wndwYn
        db.commit()

        action = "열렸습니다" if req.wndwYn == "Y" else "닫혔습니다"
        return success_response(
            f"창문이 {action}.",
            {"wndwYn": car.wndw_yn}
        )
    except Exception as e:
        return error_response(f"창문 제어 중 오류가 발생했습니다: {str(e)}", "E999")


@app.put("/api/car/{car_id}/emgncLmp", tags=["Car Control"])
def control_emgnc_lmp(
        car_id: str,
        req: schemas.EmgncLmpControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """자동차 비상등 켜기/끄기"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        car.emgnc_lmp_yn = req.emgncLmpYn
        db.commit()

        action = "켜졌습니다" if req.emgncLmpYn == "Y" else "꺼졌습니다"
        return success_response(
            f"비상등이 {action}.",
            {"emgncLmpYn": car.emgnc_lmp_yn}
        )
    except Exception as e:
        return error_response(f"비상등 제어 중 오류가 발생했습니다: {str(e)}", "E999")


@app.put("/api/car/{car_id}/tailgate", tags=["Car Control"])
def control_tailgate(
        car_id: str,
        req: schemas.TailgateControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """자동차 테일게이트 열기/닫기"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        car.tailgate_yn = req.tailgateYn
        db.commit()

        action = "열렸습니다" if req.tailgateYn == "Y" else "닫혔습니다"
        return success_response(
            f"테일게이트가 {action}.",
            {"tailgateYn": car.tailgate_yn}
        )
    except Exception as e:
        return error_response(f"테일게이트 제어 중 오류가 발생했습니다: {str(e)}", "E999")


@app.put("/api/car/{car_id}/hood", tags=["Car Control"])
def control_hood(
        car_id: str,
        req: schemas.HoodControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """자동차 후드 열기/닫기"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        car.hood_yn = req.hoodYn
        db.commit()

        action = "열렸습니다" if req.hoodYn == "Y" else "닫혔습니다"
        return success_response(
            f"후드가 {action}.",
            {"hoodYn": car.hood_yn}
        )
    except Exception as e:
        return error_response(f"후드 제어 중 오류가 발생했습니다: {str(e)}", "E999")


@app.put("/api/car/{car_id}/cdysm", tags=["Climate Control"])
def control_cdysm(
        car_id: str,
        req: schemas.CdysmControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """냉/난방 켜기/끄기"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        car.cdysm_yn = req.cdysmYn
        db.commit()

        action = "켜졌습니다" if req.cdysmYn == "Y" else "꺼졌습니다"
        return success_response(
            f"냉/난방이 {action}.",
            {"cdysmYn": car.cdysm_yn}
        )
    except Exception as e:
        return error_response(f"냉/난방 제어 중 오류가 발생했습니다: {str(e)}", "E999")


@app.put("/api/car/{car_id}/handle", tags=["Climate Control"])
def control_handle(
        car_id: str,
        req: schemas.HandleControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """핸들 열선 켜기/끄기"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        car.handle_yn = req.handleYn
        db.commit()

        action = "켜졌습니다" if req.handleYn == "Y" else "꺼졌습니다"
        return success_response(
            f"핸들 열선이 {action}.",
            {"handleYn": car.handle_yn}
        )
    except Exception as e:
        return error_response(f"핸들 열선 제어 중 오류가 발생했습니다: {str(e)}", "E999")


@app.put("/api/car/{car_id}/frontmirror", tags=["Climate Control"])
def control_frontmirror(
        car_id: str,
        req: schemas.FrontmirrorControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """앞유리 성에 제거 켜기/끄기"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        car.frontmirror_yn = req.frontmirrorYn
        db.commit()

        action = "켜졌습니다" if req.frontmirrorYn == "Y" else "꺼졌습니다"
        return success_response(
            f"앞유리 성에 제거가 {action}.",
            {"frontmirrorYn": car.frontmirror_yn}
        )
    except Exception as e:
        return error_response(f"앞유리 성에 제거 제어 중 오류가 발생했습니다: {str(e)}", "E999")


@app.put("/api/car/{car_id}/backmirrorHeat", tags=["Climate Control"])
def control_backmirror_heat(
        car_id: str,
        req: schemas.BackmirrorHeatControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """뒷유리 열선 켜기/끄기"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        car.backmirror_heat_yn = req.backmirrorHeatYn
        db.commit()

        action = "켜졌습니다" if req.backmirrorHeatYn == "Y" else "꺼졌습니다"
        return success_response(
            f"뒷유리 열선이 {action}.",
            {"backmirrorHeatYn": car.backmirror_heat_yn}
        )
    except Exception as e:
        return error_response(f"뒷유리 열선 제어 중 오류가 발생했습니다: {str(e)}", "E999")


@app.put("/api/car/{car_id}/sidemirrorHeat", tags=["Climate Control"])
def control_sidemirror_heat(
        car_id: str,
        req: schemas.SidemirrorHeatControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """사이드미러 열선 켜기/끄기"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        car.sidemirror_heat_yn = req.sidemirrorHeatYn
        db.commit()

        action = "켜졌습니다" if req.sidemirrorHeatYn == "Y" else "꺼졌습니다"
        return success_response(
            f"사이드미러 열선이 {action}.",
            {"sidemirrorHeatYn": car.sidemirror_heat_yn}
        )
    except Exception as e:
        return error_response(f"사이드미러 열선 제어 중 오류가 발생했습니다: {str(e)}", "E999")


@app.delete("/api/car/{car_id}", tags=["Car"])
def delete_car(
        car_id: str,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """자동차 삭제"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        db.delete(car)
        db.commit()

        return success_response("차량이 삭제되었습니다.", {"carId": car_id})
    except Exception as e:
        return error_response(f"차량 삭제 중 오류가 발생했습니다: {str(e)}", "E999")


# --- Car Util API ---

@app.put("/api/car/{car_id}/drvngPosblDstnc", tags=["Car Util"])
def update_distance(
        car_id: str,
        req: schemas.DistanceUpdate,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """자동차 주행 가능 거리 조정"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        car.drvng_posbl_dstnc = req.drvngPosblDstnc
        db.commit()

        return success_response(
            "주행 가능 거리가 조정되었습니다.",
            {"drvngPosblDstnc": car.drvng_posbl_dstnc}
        )
    except Exception as e:
        return error_response(f"주행 가능 거리 조정 중 오류가 발생했습니다: {str(e)}", "E999")


@app.put("/api/car/{car_id}", tags=["Car Util"])
def bulk_update_car(
        car_id: str,
        req: schemas.CarBulkUpdate,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    """자동차 상태 일괄 수정"""
    try:
        car = db.query(models.Car).filter(
            models.Car.car_id == car_id,
            models.Car.user_id == user.id
        ).first()

        if not car:
            return error_response("차량을 찾을 수 없습니다.", "E004")

        # 모든 필드 업데이트
        if req.strtgYn is not None:
            car.strtg_yn = req.strtgYn
        if req.doorYn is not None:
            car.door_yn = req.doorYn
        if req.wndwYn is not None:
            car.wndw_yn = req.wndwYn
        if req.emgncLmpYn is not None:
            car.emgnc_lmp_yn = req.emgncLmpYn
        if req.drvngPosblDstnc is not None:
            car.drvng_posbl_dstnc = req.drvngPosblDstnc
        if req.tailgateYn is not None:
            car.tailgate_yn = req.tailgateYn
        if req.hoodYn is not None:
            car.hood_yn = req.hoodYn
        if req.cdysmYn is not None:
            car.cdysm_yn = req.cdysmYn
        if req.handleYn is not None:
            car.handle_yn = req.handleYn
        if req.frontmirrorYn is not None:
            car.frontmirror_yn = req.frontmirrorYn
        if req.backmirrorHeatYn is not None:
            car.backmirror_heat_yn = req.backmirrorHeatYn
        if req.sidemirrorHeatYn is not None:
            car.sidemirror_heat_yn = req.sidemirrorHeatYn

        db.commit()
        db.refresh(car)

        return success_response(
            "차량 상태가 일괄 수정되었습니다.",
            {
                "strtgYn": car.strtg_yn,
                "doorYn": car.door_yn,
                "wndwYn": car.wndw_yn,
                "emgncLmpYn": car.emgnc_lmp_yn,
                "drvngPosblDstnc": car.drvng_posbl_dstnc,
                "tailgateYn": car.tailgate_yn,
                "hoodYn": car.hood_yn,
                "cdysmYn": car.cdysm_yn,
                "handleYn": car.handle_yn,
                "frontmirrorYn": car.frontmirror_yn,
                "backmirrorHeatYn": car.backmirror_heat_yn,
                "sidemirrorHeatYn": car.sidemirror_heat_yn
            }
        )
    except Exception as e:
        return error_response(f"차량 상태 일괄 수정 중 오류가 발생했습니다: {str(e)}", "E999")


@app.get("/", tags=["Root"])
def root():
    """API 루트"""
    return {
        "message": "Drive Mate API",
        "version": "1.0.0",
        "docs": "/docs"
    }


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)