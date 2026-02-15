--
-- Drive Mate Database Schema
-- SQLite Database
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: users
CREATE TABLE IF NOT EXISTS users (
	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	mber_id VARCHAR NOT NULL UNIQUE,
	mber_password VARCHAR NOT NULL,
	mber_nm VARCHAR NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: cars
CREATE TABLE IF NOT EXISTS cars (
	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	car_id VARCHAR NOT NULL UNIQUE,
	user_id INTEGER NOT NULL,
	car_nm VARCHAR NOT NULL,
	car_no VARCHAR NOT NULL,
	car_image VARCHAR,
	strtg_yn VARCHAR(1) DEFAULT 'N',
	door_yn VARCHAR(1) DEFAULT 'N',
	wndw_yn VARCHAR(1) DEFAULT 'N',
	emgnc_lmp_yn VARCHAR(1) DEFAULT 'N',
	drvng_posbl_dstnc INTEGER DEFAULT 100,
	tailgate_yn VARCHAR(1) DEFAULT 'N',
	hood_yn VARCHAR(1) DEFAULT 'N',
	cdysm_yn VARCHAR(1) DEFAULT 'N',
	handle_yn VARCHAR(1) DEFAULT 'N',
	frontmirror_yn VARCHAR(1) DEFAULT 'N',
	backmirror_heat_yn VARCHAR(1) DEFAULT 'N',
	sidemirror_heat_yn VARCHAR(1) DEFAULT 'N',
	temperature REAL DEFAULT 18.0,
	weather VARCHAR DEFAULT 'rainy_snow',
	location VARCHAR DEFAULT '경상북도 영천시',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY(user_id) REFERENCES users (id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS ix_users_id ON users (id);
CREATE INDEX IF NOT EXISTS ix_users_mber_id ON users (mber_id);
CREATE INDEX IF NOT EXISTS ix_cars_id ON cars (id);
CREATE INDEX IF NOT EXISTS ix_cars_car_id ON cars (car_id);
CREATE INDEX IF NOT EXISTS ix_cars_user_id ON cars (user_id);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;

--
-- Drive Mate Sample Data
-- SQLite Database
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Sample Users
INSERT INTO users (id, mber_id, mber_password, mber_nm, created_at)
VALUES (1, 'user01', '1234', '홍길동', '2025-01-01 10:00:00');

INSERT INTO users (id, mber_id, mber_password, mber_nm, created_at)
VALUES (2, 'user02', '1234', '김철수', '2025-01-02 10:00:00');

INSERT INTO users (id, mber_id, mber_password, mber_nm, created_at)
VALUES (3, 'user03', '1234', '이영희', '2025-01-03 10:00:00');

INSERT INTO users (id, mber_id, mber_password, mber_nm, created_at)
VALUES (4, 'testuser', '1234', '테스트사용자', '2025-01-04 10:00:00');

INSERT INTO users (id, mber_id, mber_password, mber_nm, created_at)
VALUES (5, 'admin', '1234', '관리자', '2025-01-05 10:00:00');

-- Sample Cars (온도, 날씨, 위치 정보 포함)
-- 주행 가능 거리 범위: 50km 미만(빨간색), 50-100km(파란색), 100km 이상(정상)
INSERT INTO cars (
	id, car_id, user_id, car_nm, car_no, car_image,
	strtg_yn, door_yn, wndw_yn, emgnc_lmp_yn, drvng_posbl_dstnc,
	tailgate_yn, hood_yn, cdysm_yn, handle_yn, frontmirror_yn,
	backmirror_heat_yn, sidemirror_heat_yn,
	temperature, weather, location, created_at
) VALUES (
	1, '862BD8845A194C74921F690BCEE2D792', 1, 'GV80', '190허 1400',
	'/static/images/profile/genesis-kr-gv80-facelift-color-glossy-mauna-red-large.png',
	'N', 'N', 'N', 'N', 25,
	'N', 'N', 'N', 'N', 'N',
	'N', 'N',
	18.0, 'rainy_snow', '경상북도 영천시', '2025-01-01 11:00:00'
);

INSERT INTO cars (
	id, car_id, user_id, car_nm, car_no, car_image,
	strtg_yn, door_yn, wndw_yn, emgnc_lmp_yn, drvng_posbl_dstnc,
	tailgate_yn, hood_yn, cdysm_yn, handle_yn, frontmirror_yn,
	backmirror_heat_yn, sidemirror_heat_yn,
	temperature, weather, location, created_at
) VALUES (
	2, 'A1B2C3D4E5F6G7H8I9J0K1L2M3N4O5P6', 1, 'G90', '서울 12가 3456',
	'/static/images/profile/genesis-kr-g90-spec-image-car-large.png',
	'Y', 'N', 'N', 'N', 78,
	'N', 'N', 'Y', 'Y', 'N',
	'N', 'N',
	22.5, 'sunny', '서울특별시 강남구', '2025-01-05 11:00:00'
);

INSERT INTO cars (
	id, car_id, user_id, car_nm, car_no, car_image,
	strtg_yn, door_yn, wndw_yn, emgnc_lmp_yn, drvng_posbl_dstnc,
	tailgate_yn, hood_yn, cdysm_yn, handle_yn, frontmirror_yn,
	backmirror_heat_yn, sidemirror_heat_yn,
	temperature, weather, location, created_at
) VALUES (
	3, 'QWERTYUIOPASDFGHJKLZXCVBNM123456', 2, 'GV70', '경기 98나 7654',
	'/static/images/profile/genesis-kr-electrified-gv70-colors-glossy-capri-blue-large.png',
	'N', 'Y', 'N', 'N', 150,
	'N', 'N', 'N', 'N', 'N',
	'N', 'N',
	15.0, 'cloudy_snowing', '경기도 성남시', '2025-01-10 14:00:00'
);

INSERT INTO cars (
	id, car_id, user_id, car_nm, car_no, car_image,
	strtg_yn, door_yn, wndw_yn, emgnc_lmp_yn, drvng_posbl_dstnc,
	tailgate_yn, hood_yn, cdysm_yn, handle_yn, frontmirror_yn,
	backmirror_heat_yn, sidemirror_heat_yn,
	temperature, weather, location, created_at
) VALUES (
	4, 'B2C3D4E5F6G7H8I9J0K1L2M3N4O5P6Q7', 2, 'G80 Sport', '부산 77마 8899',
	'/static/images/profile/genesis-kr-g80-facelift-sport-color-glossy-cavendish-red-large.png',
	'Y', 'Y', 'N', 'N', 12,
	'N', 'N', 'Y', 'N', 'Y',
	'Y', 'Y',
	25.0, 'cloud', '부산광역시 해운대구', '2025-01-15 16:00:00'
);

INSERT INTO cars (
	id, car_id, user_id, car_nm, car_no, car_image,
	strtg_yn, door_yn, wndw_yn, emgnc_lmp_yn, drvng_posbl_dstnc,
	tailgate_yn, hood_yn, cdysm_yn, handle_yn, frontmirror_yn,
	backmirror_heat_yn, sidemirror_heat_yn,
	temperature, weather, location, created_at
) VALUES (
	5, 'C3D4E5F6G7H8I9J0K1L2M3N4O5P6Q7R8', 3, 'BMW i8', '인천 55바 1122',
	'/static/images/profile/i8.png',
	'N', 'N', 'N', 'N', 63,
	'N', 'N', 'N', 'N', 'N',
	'N', 'N',
	10.0, 'rainy', '인천광역시 연수구', '2025-01-20 10:00:00'
);

INSERT INTO cars (
	id, car_id, user_id, car_nm, car_no, car_image,
	strtg_yn, door_yn, wndw_yn, emgnc_lmp_yn, drvng_posbl_dstnc,
	tailgate_yn, hood_yn, cdysm_yn, handle_yn, frontmirror_yn,
	backmirror_heat_yn, sidemirror_heat_yn,
	temperature, weather, location, created_at
) VALUES (
	6, 'D4E5F6G7H8I9J0K1L2M3N4O5P6Q7R8S9', 3, 'Audi Q7', '대전 33사 4455',
	'/static/images/profile/q7.png',
	'Y', 'N', 'Y', 'N', 200,
	'Y', 'N', 'Y', 'Y', 'N',
	'N', 'Y',
	20.0, 'thunderstorm', '대전광역시 유성구', '2025-01-22 14:00:00'
);

INSERT INTO cars (
	id, car_id, user_id, car_nm, car_no, car_image,
	strtg_yn, door_yn, wndw_yn, emgnc_lmp_yn, drvng_posbl_dstnc,
	tailgate_yn, hood_yn, cdysm_yn, handle_yn, frontmirror_yn,
	backmirror_heat_yn, sidemirror_heat_yn,
	temperature, weather, location, created_at
) VALUES (
	7, 'E5F6G7H8I9J0K1L2M3N4O5P6Q7R8S9T0', 4, 'Audi A8', '광주 88아 9988',
	'/static/images/profile/a8.png',
	'N', 'N', 'N', 'N', 42,
	'N', 'N', 'N', 'N', 'N',
	'N', 'N',
	12.0, 'rainy_snow', '광주광역시 서구', '2025-01-25 09:00:00'
);

INSERT INTO cars (
	id, car_id, user_id, car_nm, car_no, car_image,
	strtg_yn, door_yn, wndw_yn, emgnc_lmp_yn, drvng_posbl_dstnc,
	tailgate_yn, hood_yn, cdysm_yn, handle_yn, frontmirror_yn,
	backmirror_heat_yn, sidemirror_heat_yn,
	temperature, weather, location, created_at
) VALUES (
	8, 'F6G7H8I9J0K1L2M3N4O5P6Q7R8S9T0U1', 4, 'Genesis G70', '울산 45아 6789',
	'/static/images/profile/genesis-kr-gv80-facelift-color-glossy-uyuni-white-large.png',
	'Y', 'N', 'N', 'Y', 95,
	'N', 'N', 'Y', 'N', 'N',
	'Y', 'N',
	16.5, 'sunny', '울산광역시 남구', '2025-01-28 15:30:00'
);

INSERT INTO cars (
	id, car_id, user_id, car_nm, car_no, car_image,
	strtg_yn, door_yn, wndw_yn, emgnc_lmp_yn, drvng_posbl_dstnc,
	tailgate_yn, hood_yn, cdysm_yn, handle_yn, frontmirror_yn,
	backmirror_heat_yn, sidemirror_heat_yn,
	temperature, weather, location, created_at
) VALUES (
	9, 'G7H8I9J0K1L2M3N4O5P6Q7R8S9T0U1V2', 5, 'GV80 Coupe', '대구 22바 3344',
	'/static/images/profile/genesis-kr-g80-facelift-sport-color-glossy-savile-silver-large.png',
	'N', 'Y', 'Y', 'N', 8,
	'Y', 'N', 'N', 'N', 'Y',
	'N', 'N',
	8.0, 'cloudy_snowing', '대구광역시 수성구', '2025-02-01 08:00:00'
);

INSERT INTO cars (
	id, car_id, user_id, car_nm, car_no, car_image,
	strtg_yn, door_yn, wndw_yn, emgnc_lmp_yn, drvng_posbl_dstnc,
	tailgate_yn, hood_yn, cdysm_yn, handle_yn, frontmirror_yn,
	backmirror_heat_yn, sidemirror_heat_yn,
	temperature, weather, location, created_at
) VALUES (
	10, 'H8I9J0K1L2M3N4O5P6Q7R8S9T0U1V2W3', 5, 'Tesla Model S', '세종 11나 5566',
	'/static/images/profile/genesis-kr-electrified-gv70-colors-glossy-capri-blue-large.png',
	'Y', 'N', 'Y', 'N', 320,
	'N', 'N', 'Y', 'Y', 'Y',
	'Y', 'Y',
	19.0, 'cloud', '세종특별자치시', '2025-02-05 12:00:00'
);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;