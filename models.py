from sqlalchemy import Column, Integer, String, DateTime, Float, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    mber_id = Column(String, unique=True, nullable=False, index=True)
    mber_password = Column(String, nullable=False)
    mber_nm = Column(String, nullable=False)
    created_at = Column(DateTime, default=datetime.now)

    # 관계
    cars = relationship("Car", back_populates="owner")


class Car(Base):
    __tablename__ = "cars"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    car_id = Column(String, unique=True, nullable=False, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    car_nm = Column(String, nullable=False)
    car_no = Column(String, nullable=False)
    car_image = Column(String, nullable=True)

    # 차량 상태 (Y/N)
    strtg_yn = Column(String(1), default="N")
    door_yn = Column(String(1), default="N")
    wndw_yn = Column(String(1), default="N")
    emgnc_lmp_yn = Column(String(1), default="N")
    tailgate_yn = Column(String(1), default="N")
    hood_yn = Column(String(1), default="N")

    # 공조 상태 (Y/N)
    cdysm_yn = Column(String(1), default="N")
    handle_yn = Column(String(1), default="N")
    frontmirror_yn = Column(String(1), default="N")
    backmirror_heat_yn = Column(String(1), default="N")
    sidemirror_heat_yn = Column(String(1), default="N")

    # 주행 가능 거리 (정수)
    drvng_posbl_dstnc = Column(Integer, default=100)

    # 날씨 정보
    temperature = Column(Float, default=18.0)  # 섭씨 온도
    weather = Column(String, default="rainy_snow")  # 날씨 타입
    location = Column(String, default="경상북도 영천시")  # 위치

    created_at = Column(DateTime, default=datetime.now)

    # 관계
    owner = relationship("User", back_populates="cars")