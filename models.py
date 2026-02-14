from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    mber_id = Column(String, unique=True, nullable=False)
    mber_password = Column(String, nullable=False)
    mber_nm = Column(String, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    cars = relationship("Car", back_populates="user")


class Car(Base):
    __tablename__ = "cars"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    car_id = Column(String, unique=True, nullable=False, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    car_nm = Column(String, nullable=False)
    car_no = Column(String, nullable=False)
    car_image = Column(String, nullable=True)

    # 차량 상태 필드
    strtg_yn = Column(String(1), default="N")  # 시동
    door_yn = Column(String(1), default="N")  # 도어
    wndw_yn = Column(String(1), default="N")  # 창문
    emgnc_lmp_yn = Column(String(1), default="N")  # 비상등
    drvng_posbl_dstnc = Column(Integer, default=100)  # 주행가능거리
    tailgate_yn = Column(String(1), default="N")  # 테일게이트
    hood_yn = Column(String(1), default="N")  # 후드
    cdysm_yn = Column(String(1), default="N")  # 냉/난방
    handle_yn = Column(String(1), default="N")  # 핸들 열선
    frontmirror_yn = Column(String(1), default="N")  # 앞유리 성에 제거
    backmirror_heat_yn = Column(String(1), default="N")  # 뒷유리 열선
    sidemirror_heat_yn = Column(String(1), default="N")  # 사이드미러 열선

    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="cars")