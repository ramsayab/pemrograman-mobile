from datetime import datetime
import os

from fastapi import FastAPI, HTTPException
from sqlalchemy import text

from .database import engine

app = FastAPI(title="TabungKu API", version="0.1.0")

@app.get("/")
def beranda():
    return {"pesan": "Selamat datang di TabungKu API. Dokumentasi: /docs"}

@app.get("/health")
def health():
    """Periksa API dan koneksi database MySQL."""
    waktu_server = datetime.now().isoformat(timespec="seconds")
    try:
        with engine.connect() as connection:
            mysql_version = connection.execute(text("SELECT VERSION()")).scalar_one()
    except Exception as error:
        raise HTTPException(
            status_code=503,
            detail={
                "status": "error",
                "waktu_server": waktu_server,
                "database": "error",
                "pesan": str(error),
            },
        ) from error

    return {
        "status": "ok",
        "waktu_server": waktu_server,
        "database": "ok",
        "mysql_version": mysql_version,
    }

@app.get("/info")
def info():
    """Informasi dasar aplikasi."""
    return {
        "nama_aplikasi": app.title,
        "versi": app.version,
        "zona_waktu": os.environ.get("TZ", "UTC"),
    }
