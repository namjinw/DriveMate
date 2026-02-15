from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


# --- Authentication Schemas ---
class SignupRequest(BaseModel):
    mberId: str = Field(..., min_length=4, description="사용자 ID (4자 이상)")
    mberPassword: str = Field(..., min_length=4, description="비밀번호 (4자 이상)")
    mberNm: str = Field(..., description="사용자 이름")


class SigninRequest(BaseModel):
    mberId: str
    mberPassword: str


class AuthResponse(BaseModel):
    STATUS_CD: str
    message: str
    data: dict


# --- Car Control Schemas ---
class StrtgControl(BaseModel):
    strtgYn: str = Field(..., pattern="^[YN]$", description="시동 상태 (Y/N)")


class DoorControl(BaseModel):
    doorYn: str = Field(..., pattern="^[YN]$", description="도어 상태 (Y/N)")


class WndwControl(BaseModel):
    wndwYn: str = Field(..., pattern="^[YN]$", description="창문 상태 (Y/N)")


class EmgncLmpControl(BaseModel):
    emgncLmpYn: str = Field(..., pattern="^[YN]$", description="비상등 상태 (Y/N)")


class TailgateControl(BaseModel):
    tailgateYn: str = Field(..., pattern="^[YN]$", description="테일게이트 상태 (Y/N)")


class HoodControl(BaseModel):
    hoodYn: str = Field(..., pattern="^[YN]$", description="후드 상태 (Y/N)")


class CdysmControl(BaseModel):
    cdysmYn: str = Field(..., pattern="^[YN]$", description="냉/난방 상태 (Y/N)")


class HandleControl(BaseModel):
    handleYn: str = Field(..., pattern="^[YN]$", description="핸들 열선 상태 (Y/N)")


class FrontmirrorControl(BaseModel):
    frontmirrorYn: str = Field(..., pattern="^[YN]$", description="앞유리 성에 제거 상태 (Y/N)")


class BackmirrorHeatControl(BaseModel):
    backmirrorHeatYn: str = Field(..., pattern="^[YN]$", description="뒷유리 열선 상태 (Y/N)")


class SidemirrorHeatControl(BaseModel):
    sidemirrorHeatYn: str = Field(..., pattern="^[YN]$", description="사이드미러 열선 상태 (Y/N)")


# --- Car Util Schemas ---
class DistanceUpdate(BaseModel):
    drvngPosblDstnc: int = Field(..., ge=0, description="주행 가능 거리 (km)")


class CarBulkUpdate(BaseModel):
    strtgYn: Optional[str] = Field(None, pattern="^[YN]$")
    doorYn: Optional[str] = Field(None, pattern="^[YN]$")
    wndwYn: Optional[str] = Field(None, pattern="^[YN]$")
    emgncLmpYn: Optional[str] = Field(None, pattern="^[YN]$")
    drvngPosblDstnc: Optional[int] = Field(None, ge=0)
    tailgateYn: Optional[str] = Field(None, pattern="^[YN]$")
    hoodYn: Optional[str] = Field(None, pattern="^[YN]$")
    cdysmYn: Optional[str] = Field(None, pattern="^[YN]$")
    handleYn: Optional[str] = Field(None, pattern="^[YN]$")
    frontmirrorYn: Optional[str] = Field(None, pattern="^[YN]$")
    backmirrorHeatYn: Optional[str] = Field(None, pattern="^[YN]$")
    sidemirrorHeatYn: Optional[str] = Field(None, pattern="^[YN]$")


# --- Response Schemas ---
class CarListResponse(BaseModel):
    carId: str
    carNm: str
    carNo: str
    carImage: Optional[str]
    temperature: str  # "18 °C" 형식
    weather: str
    location: str
    drvngPosblDstnc: int  # 주행 가능 거리 (기본 응답에 포함)


class CarDetailResponse(BaseModel):
    carId: str
    carNm: str
    carNo: str
    carImage: Optional[str]
    temperature: str
    weather: str
    location: str
    drvngPosblDstnc: int  # 주행 가능 거리 (항상 포함)
    strtgYn: Optional[str] = None
    doorYn: Optional[str] = None
    wndwYn: Optional[str] = None
    emgncLmpYn: Optional[str] = None
    tailgateYn: Optional[str] = None
    hoodYn: Optional[str] = None
    cdysmYn: Optional[str] = None
    handleYn: Optional[str] = None
    frontmirrorYn: Optional[str] = None
    backmirrorHeatYn: Optional[str] = None
    sidemirrorHeatYn: Optional[str] = None