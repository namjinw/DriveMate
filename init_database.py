"""
Drive Mate Database Initialization Script

데이터베이스를 생성하고 샘플 데이터를 삽입합니다.
"""

import sqlite3
import os

DB_FILE = "drive_mate.db"


def execute_sql_file(cursor, filepath):
    """SQL 파일을 읽어서 실행"""
    print(f"Executing {filepath}...")
    with open(filepath, 'r', encoding='utf-8') as f:
        sql_script = f.read()
        cursor.executescript(sql_script)
    print(f"✓ {filepath} executed successfully")


def init_database():
    """데이터베이스 초기화"""

    # 기존 DB 파일이 있으면 삭제 (선택사항)
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
        # 1. 테이블 생성
        execute_sql_file(cursor, 'app.sql')

        # 커밋
        conn.commit()
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
               c.strtg_yn, c.drvng_posbl_dstnc, c.created_at
        FROM cars c
        JOIN users u ON c.user_id = u.id
    """)
    cars = cursor.fetchall()
    for car in cars:
        print(f"ID: {car[0]}, 차량ID: {car[1]}, 소유자: {car[2]}, "
              f"차량명: {car[3]}, 차량번호: {car[4]}, "
              f"시동: {car[5]}, 주행거리: {car[6]}km, 생성일: {car[7]}")

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