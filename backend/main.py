from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
import sqlite3
from datetime import datetime

app = FastAPI(title="Flutter Jenkins API")
DB_PATH = "users.db"

def init_db():
    conn = sqlite3.connect(DB_PATH)
    conn.execute('''CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        created_at TEXT NOT NULL
    )''')
    conn.commit()
    conn.close()

init_db()

class UserCreate(BaseModel):
    name: str
    email: str

class User(BaseModel):
    id: int
    name: str
    email: str
    created_at: str

@app.get("/")
def root():
    return {"status": "ok", "message": "API berjalan!"}

@app.get("/users", response_model=List[User])
def get_users():
    conn = sqlite3.connect(DB_PATH)
    rows = conn.execute("SELECT id,name,email,created_at FROM users").fetchall()
    conn.close()
    return [{"id":r[0],"name":r[1],"email":r[2],"created_at":r[3]} for r in rows]

@app.post("/users", response_model=User)
def create_user(u: UserCreate):
    conn = sqlite3.connect(DB_PATH)
    try:
        now = datetime.now().isoformat()
        cur = conn.execute(
            "INSERT INTO users(name,email,created_at) VALUES(?,?,?)",
            (u.name, u.email, now)
        )
        conn.commit()
        return {"id": cur.lastrowid, "name": u.name, "email": u.email, "created_at": now}
    except sqlite3.IntegrityError:
        raise HTTPException(400, "Email sudah dipakai")
    finally:
        conn.close()

@app.delete("/users/{uid}")
def delete_user(uid: int):
    conn = sqlite3.connect(DB_PATH)
    cur = conn.execute("DELETE FROM users WHERE id=?", (uid,))
    conn.commit()
    conn.close()
    if cur.rowcount == 0:
        raise HTTPException(404, "User tidak ditemukan")
    return {"message": "Dihapus"}