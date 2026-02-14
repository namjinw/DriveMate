from pydantic import BaseModel
from typing import Optional

# --- Authentication Schemas ---
class SignupRequest(BaseModel):
    mberId: str
    mberPassword: str
    mberNm: str

class SigninRequest(BaseModel):
    mberId: str
    mberPassword: str

# --- Car Control Schemas ---
class StrtgControl(BaseModel):
    strtgYn: str

class DoorControl(BaseModel):
    doorYn: str

class WndwControl(BaseModel):
    wndwYn: str

class EmgncLmpControl(BaseModel):
    emgncLmpYn: str

# --- Car Util Schemas ---
class DistanceUpdate(BaseModel):
    drvngPosblDstnc: int

class CarBulkUpdate(BaseModel):
    strtgYn: Optional[str] = None
    doorYn: Optional[str] = None
    wndwYn: Optional[str] = None
    emgncLmpYn: Optional[str] = None
    drvngPosblDstnc: Optional[int] = None
    tailgateYn: Optional[str] = None
    hoodYn: Optional[str] = None
    cdysmYn: Optional[str] = None
    handleYn: Optional[str] = None
    frontmirrorYn: Optional[str] = None
    backmirrorHeatYn: Optional[str] = None
    sidemirrorHeatYn: Optional[str] = None