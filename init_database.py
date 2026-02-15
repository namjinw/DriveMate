"""
Drive Mate Database Initialization Script

데이터베이스를 생성하고 샘플 데이터를 삽입합니다.
"""

import sqlite3
import os
from datetime import datetime

DB_FILE = "drive_mate.db"


def init_database():
    """데이터베이스 초기화"""

    # 기존 DB 파일이 있으면 삭제
    if os.path.exists(DB_FILE):
        print(f"기존 데이터베이스 파일 '{DB_FILE}'이 존재합니다.")
        response = input("삭제하고 새로 생성하시겠습니까? (y/N): ")
        if response.lower() == 'y':
            os.remove(DB_FILE)
            print(f"✓ 기존 데이터베이스 파일 삭제됨")
        else:
            print("초기화를 취소합니다.")
            return

    # 데이터베이스 연결
    print(f"\n데이터베이스 '{DB_FILE}' 생성 중...")
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()

    try:
        # Foreign keys 활성화
        cursor.execute("PRAGMA foreign_keys = OFF;")

        # 테이블 생성
        print("테이블 생성 중...")

        # Users 테이블
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            mber_id VARCHAR NOT NULL UNIQUE,
            mber_password VARCHAR NOT NULL,
            mber_nm VARCHAR NOT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
        """)

        # Cars 테이블
        cursor.execute("""
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
        """)

        # 인덱스 생성
        cursor.execute("CREATE INDEX IF NOT EXISTS ix_users_id ON users (id);")
        cursor.execute("CREATE INDEX IF NOT EXISTS ix_users_mber_id ON users (mber_id);")
        cursor.execute("CREATE INDEX IF NOT EXISTS ix_cars_id ON cars (id);")
        cursor.execute("CREATE INDEX IF NOT EXISTS ix_cars_car_id ON cars (car_id);")
        cursor.execute("CREATE INDEX IF NOT EXISTS ix_cars_user_id ON cars (user_id);")

        print("✓ 테이블 생성 완료")

        # 샘플 데이터 삽입
        print("\n샘플 데이터 삽입 중...")

        # Sample Users
        users = [
            (1, 'user01', '1234', '홍길동', '2025-01-01 10:00:00'),
            (2, 'user02', '1234', '김철수', '2025-01-02 10:00:00'),
            (3, 'user03', '1234', '이영희', '2025-01-03 10:00:00'),
            (4, 'testuser', '1234', '테스트사용자', '2025-01-04 10:00:00'),
            (5, 'admin', '1234', '관리자', '2025-01-05 10:00:00'),
        ]

        cursor.executemany("""
        INSERT INTO users (id, mber_id, mber_password, mber_nm, created_at)
        VALUES (?, ?, ?, ?, ?)
        """, users)

        # Sample Cars with varied data
        # 주행 가능 거리: 50km 미만(빨간색) / 50-100km(파란색) / 100km 이상(정상)
        cars = [
            (1, '862BD8845A194C74921F690BCEE2D792', 1, 'GV80', '190허 1400',
             '/static/images/profile/genesis-kr-gv80-facelift-color-glossy-mauna-red-large.png',
             'N', 'N', 'N', 'N', 25, 'N', 'N', 'N', 'N', 'N', 'N', 'N',
             18.0, 'rainy_snow', '경상북도 영천시', '2025-01-01 11:00:00'),

            (2, 'A1B2C3D4E5F6G7H8I9J0K1L2M3N4O5P6', 1, 'G90', '서울 12가 3456',
             '/static/images/profile/genesis-kr-g90-spec-image-car-large.png',
             'Y', 'N', 'N', 'N', 78, 'N', 'N', 'Y', 'Y', 'N', 'N', 'N',
             22.5, 'sunny', '서울특별시 강남구', '2025-01-05 11:00:00'),

            (3, 'QWERTYUIOPASDFGHJKLZXCVBNM123456', 2, 'GV70', '경기 98나 7654',
             '/static/images/profile/genesis-kr-electrified-gv70-colors-glossy-capri-blue-large.png',
             'N', 'Y', 'N', 'N', 150, 'N', 'N', 'N', 'N', 'N', 'N', 'N',
             15.0, 'cloudy_snowing', '경기도 성남시', '2025-01-10 14:00:00'),

            (4, 'B2C3D4E5F6G7H8I9J0K1L2M3N4O5P6Q7', 2, 'G80 Sport', '부산 77마 8899',
             '/static/images/profile/genesis-kr-g80-facelift-sport-color-glossy-cavendish-red-large.png',
             'Y', 'Y', 'N', 'N', 12, 'N', 'N', 'Y', 'N', 'Y', 'Y', 'Y',
             25.0, 'cloud', '부산광역시 해운대구', '2025-01-15 16:00:00'),

            (5, 'C3D4E5F6G7H8I9J0K1L2M3N4O5P6Q7R8', 3, 'BMW i8', '인천 55바 1122',
             '/static/images/profile/i8.png',
             'N', 'N', 'N', 'N', 63, 'N', 'N', 'N', 'N', 'N', 'N', 'N',
             10.0, 'rainy', '인천광역시 연수구', '2025-01-20 10:00:00'),

            (6, 'D4E5F6G7H8I9J0K1L2M3N4O5P6Q7R8S9', 3, 'Audi Q7', '대전 33사 4455',
             '/static/images/profile/q7.png',
             'Y', 'N', 'Y', 'N', 200, 'Y', 'N', 'Y', 'Y', 'N', 'N', 'Y',
             20.0, 'thunderstorm', '대전광역시 유성구', '2025-01-22 14:00:00'),

            (7, 'E5F6G7H8I9J0K1L2M3N4O5P6Q7R8S9T0', 4, 'Audi A8', '광주 88아 9988',
             '/static/images/profile/a8.png',
             'N', 'N', 'N', 'N', 42, 'N', 'N', 'N', 'N', 'N', 'N', 'N',
             12.0, 'rainy_snow', '광주광역시 서구', '2025-01-25 09:00:00'),

            (8, 'F6G7H8I9J0K1L2M3N4O5P6Q7R8S9T0U1', 4, 'Genesis G70', '울산 45아 6789',
             '/static/images/profile/genesis-kr-gv80-facelift-color-glossy-uyuni-white-large.png',
             'Y', 'N', 'N', 'Y', 95, 'N', 'N', 'Y', 'N', 'N', 'Y', 'N',
             16.5, 'sunny', '울산광역시 남구', '2025-01-28 15:30:00'),

            (9, 'G7H8I9J0K1L2M3N4O5P6Q7R8S9T0U1V2', 5, 'GV80 Coupe', '대구 22바 3344',
             '/static/images/profile/genesis-kr-g80-facelift-sport-color-glossy-savile-silver-large.png',
             'N', 'Y', 'Y', 'N', 8, 'Y', 'N', 'N', 'N', 'Y', 'N', 'N',
             8.0, 'cloudy_snowing', '대구광역시 수성구', '2025-02-01 08:00:00'),

            (10, 'H8I9J0K1L2M3N4O5P6Q7R8S9T0U1V2W3', 5, 'Tesla Model S', '세종 11나 5566',
             '/static/images/profile/genesis-kr-electrified-gv70-colors-glossy-capri-blue-large.png',
             'Y', 'N', 'Y', 'N', 320, 'N', 'N', 'Y', 'Y', 'Y', 'Y', 'Y',
             19.0, 'cloud', '세종특별자치시', '2025-02-05 12:00:00'),
        ]

        cursor.executemany("""
        INSERT INTO cars (
            id, car_id, user_id, car_nm, car_no, car_image,
            strtg_yn, door_yn, wndw_yn, emgnc_lmp_yn, drvng_posbl_dstnc,
            tailgate_yn, hood_yn, cdysm_yn, handle_yn, frontmirror_yn,
            backmirror_heat_yn, sidemirror_heat_yn,
            temperature, weather, location, created_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, cars)

        print("✓ 샘플 데이터 삽입 완료")

        # 커밋
        conn.commit()
        cursor.execute("PRAGMA foreign_keys = ON;")

        print("\n✓ 데이터베이스 초기화 완료!")

        # 생성된 테이블 확인
        print("\n생성된 테이블:")
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = cursor.fetchall()
        for table in tables:
            print(f"  - {table[0]}")

        # 데이터 확인
        print("\n삽입된 데이터:")
        cursor.execute("SELECT COUNT(*) FROM users")
        user_count = cursor.fetchone()[0]
        print(f"  - users: {user_count} rows")

        cursor.execute("SELECT COUNT(*) FROM cars")
        car_count = cursor.fetchone()[0]
        print(f"  - cars: {car_count} rows")

    except Exception as e:
        print(f"\n✗ 오류 발생: {str(e)}")
        conn.rollback()
    finally:
        conn.close()
        print(f"\n데이터베이스 연결 종료")


def verify_database():
    """데이터베이스 내용 확인"""
    if not os.path.exists(DB_FILE):
        print(f"데이터베이스 파일 '{DB_FILE}'이 존재하지 않습니다.")
        return

    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()

    print("\n=== 사용자 목록 ===")
    cursor.execute("SELECT id, mber_id, mber_nm, created_at FROM users")
    users = cursor.fetchall()
    for user in users:
        print(f"ID: {user[0]}, 아이디: {user[1]}, 이름: {user[2]}, 생성일: {user[3]}")

    print("\n=== 차량 목록 ===")
    cursor.execute("""
        SELECT c.id, c.car_id, u.mber_nm, c.car_nm, c.car_no, 
               c.strtg_yn, c.drvng_posbl_dstnc, c.temperature, c.weather, c.location, c.created_at
        FROM cars c
        JOIN users u ON c.user_id = u.id
    """)
    cars = cursor.fetchall()
    for car in cars:
        print(f"ID: {car[0]}, 차량ID: {car[1]}, 소유자: {car[2]}, "
              f"차량명: {car[3]}, 차량번호: {car[4]}, "
              f"시동: {car[5]}, 주행거리: {car[6]}km, 온도: {car[7]}°C, "
              f"날씨: {car[8]}, 위치: {car[9]}, 생성일: {car[10]}")

    print("\n=== 차량별 상세 상태 ===")
    cursor.execute("""
        SELECT c.car_nm, c.car_no,
               c.strtg_yn, c.door_yn, c.wndw_yn, c.emgnc_lmp_yn,
               c.tailgate_yn, c.hood_yn,
               c.cdysm_yn, c.handle_yn, c.frontmirror_yn,
               c.backmirror_heat_yn, c.sidemirror_heat_yn
        FROM cars c
    """)
    cars = cursor.fetchall()
    for car in cars:
        print(f"\n{car[0]} ({car[1]}):")
        print(f"  차량: 시동={car[2]}, 도어={car[3]}, 창문={car[4]}, 비상등={car[5]}, "
              f"테일게이트={car[6]}, 후드={car[7]}")
        print(f"  공조: 냉난방={car[8]}, 핸들열선={car[9]}, 앞유리={car[10]}, "
              f"뒷유리열선={car[11]}, 사이드미러열선={car[12]}")

    conn.close()


if __name__ == "__main__":
    print("=" * 60)
    print("Drive Mate Database Initialization")
    print("=" * 60)

    print("\n메뉴를 선택하세요:")
    print("1. 데이터베이스 초기화 (테이블 생성 + 샘플 데이터)")
    print("2. 데이터베이스 내용 확인")
    print("3. 종료")

    choice = input("\n선택 (1-3): ")

    if choice == '1':
        init_database()
    elif choice == '2':
        verify_database()
    elif choice == '3':
        print("종료합니다.")
    else:
        print("잘못된 선택입니다.")