import sqlite3
import random
from faker import Faker

DB_NAME = "tasks.db"

fake = Faker()

def create_connection(db_name):
    conn = sqlite3.connect(db_name)
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn

def seed_statuses(conn):
    statuses = [('new',), ('in progress',), ('completed',)]
    conn.executemany("INSERT OR IGNORE INTO status (name) VALUES (?);", statuses)
    conn.commit()

def seed_users(conn, num_users=10):
    users_data = []
    for _ in range(num_users):
        fullname = fake.name()
        email = fake.unique.email()
        users_data.append((fullname, email))
    conn.executemany(
        "INSERT INTO users (fullname, email) VALUES (?, ?);",
        users_data
    )
    conn.commit()

def get_all_ids(conn, table_name):
    cur = conn.cursor()
    cur.execute(f"SELECT id FROM {table_name};")
    return [row[0] for row in cur.fetchall()]

def seed_tasks(conn, num_tasks=30):
    user_ids = get_all_ids(conn, "users")
    status_ids = get_all_ids(conn, "status")

    tasks_data = []
    for _ in range(num_tasks):
        title = fake.sentence(nb_words=4).rstrip(".")
        description = fake.paragraph() if random.random() > 0.3 else None
        status_id = random.choice(status_ids)
        user_id = random.choice(user_ids)
        tasks_data.append((title, description, status_id, user_id))

    conn.executemany(
        """
        INSERT INTO tasks (title, description, status_id, user_id)
        VALUES (?, ?, ?, ?);
        """,
        tasks_data
    )
    conn.commit()

def main():
    conn = create_connection(DB_NAME)

    seed_statuses(conn)
    seed_users(conn, num_users=10)
    seed_tasks(conn, num_tasks=30)

    conn.close()
    print("Seeding done!")

if __name__ == "__main__":
    main()
