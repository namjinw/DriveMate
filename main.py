from fastapi import FastAPI, Depends, HTTPException, Request, File, UploadFile, Form
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from sqlalchemy.orm import Session
from jose import jwt
from datetime import datetime, timedelta
from typing import Optional
import os
import uuid

import models, schemas
from database import SessionLocal, engine, Base, get_db

# 테이블 생성
Base.metadata.create_all(bind=engine)

from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

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
    payload = {
        "userId": user_id,
        "exp": datetime.utcnow() + timedelta(hours=24)
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def get_current_user(request: Request, db: Session = Depends(get_db)):
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
    return {
        "STATUS_CD": status_cd,
        "message": message,
        "data": data
    }


def error_response(message: str = "오류 발생", status_cd: str = "E001"):
    return JSONResponse(
        status_code=400,
        content={
            "STATUS_CD": status_cd,
            "message": message
        }
    )


# --- Authentication API ---

@app.post("/api/authenticate/signup")
def signup(
        mberId: str = Form(...),
        mberPassword: str = Form(...),
        mberNm: str = Form(...)
):
    db = SessionLocal()
    try:
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


@app.post("/api/authenticate/signin")
def signin(
        mberId: str = Form(...),
        mberPassword: str = Form(...)
):
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


@app.get("/api/authenticate/signout")
def signout(user: models.User = Depends(get_current_user)):
    # 로그아웃 시 새로운 토큰 발급 (기존 토큰 무효화 개념)
    new_token = create_token(user.mber_id)
    return success_response(
        "로그아웃되었습니다.",
        {"token": new_token}
    )


# --- Car API ---

@app.post("/api/car")
async def register_car_with_image(
        carNm: str = Form(...),
        carNo: str = Form(...),
        file: Optional[UploadFile] = File(None),
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
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
            drvng_posbl_dstnc=100,
            tailgate_yn="N",
            hood_yn="N",
            cdysm_yn="N",
            handle_yn="N",
            frontmirror_yn="N",
            backmirror_heat_yn="N",
            sidemirror_heat_yn="N"
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


@app.post("/api/car-noupload")
def register_car_no_upload(
        carNm: str = Form(...),
        carNo: str = Form(...),
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
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
            drvng_posbl_dstnc=100,
            tailgate_yn="N",
            hood_yn="N",
            cdysm_yn="N",
            handle_yn="N",
            frontmirror_yn="N",
            backmirror_heat_yn="N",
            sidemirror_heat_yn="N"
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


@app.get("/api/car")
def get_car_list(
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
    try:
        cars = db.query(models.Car).filter(models.Car.user_id == user.id).all()

        car_list = []
        for car in cars:
            car_list.append({
                "carId": car.car_id,
                "carNm": car.car_nm,
                "carNo": car.car_no,
                "carImage": car.car_image,
                "temperature": "18 °C",
                "weather": "rainy_snow",
                "location": "경상북도 영천시"
            })

        return success_response("차량 목록 조회 성공", car_list)
    except Exception as e:
        return error_response(f"차량 목록 조회 중 오류가 발생했습니다: {str(e)}", "E999")


@app.get("/api/car/{car_id}")
def get_car_detail(
        car_id: str,
        detailYn: Optional[str] = "N",
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
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
            "temperature": "18 °C",
            "weather": "rainy_snow",
            "location": "경상북도 영천시"
        }

        if detailYn == "Y":
            car_data.update({
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
            })

        return success_response("차량 조회 성공", car_data)
    except Exception as e:
        return error_response(f"차량 조회 중 오류가 발생했습니다: {str(e)}", "E999")


@app.put("/api/car/{car_id}/strtg")
def control_strtg(
        car_id: str,
        req: schemas.StrtgControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
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


@app.put("/api/car/{car_id}/door")
def control_door(
        car_id: str,
        req: schemas.DoorControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
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


@app.put("/api/car/{car_id}/wndw")
def control_wndw(
        car_id: str,
        req: schemas.WndwControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
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


@app.put("/api/car/{car_id}/emgncLmp")
def control_emgnc_lmp(
        car_id: str,
        req: schemas.EmgncLmpControl,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
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


@app.delete("/api/car/{car_id}")
def delete_car(
        car_id: str,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
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

@app.put("/api/car/{car_id}/drvngPosblDstnc")
def update_distance(
        car_id: str,
        req: schemas.DistanceUpdate,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
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


@app.put("/api/car/{car_id}")
def bulk_update_car(
        car_id: str,
        req: schemas.CarBulkUpdate,
        user: models.User = Depends(get_current_user),
        db: Session = Depends(get_db)
):
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


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)