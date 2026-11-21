import os

from fastapi import FastAPI

from .routers import health, kegiatan, laporan

app = FastAPI(title="TabungKu API", version="0.2.0")


@app.get("/")
def beranda():
    return {"pesan": "Selamat datang di TabungKu API. Dokumentasi: /docs"}


@app.get("/info")
def info():
    return {
        "nama_aplikasi": app.title,
        "versi": app.version,
        "zona_waktu": os.environ.get("TZ", "UTC"),
    }


app.include_router(health.router)
app.include_router(kegiatan.router)
app.include_router(laporan.router)
