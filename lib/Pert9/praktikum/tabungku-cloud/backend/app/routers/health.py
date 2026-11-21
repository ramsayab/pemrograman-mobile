from datetime import datetime

from fastapi import APIRouter, HTTPException
from sqlalchemy import text

from ..database import engine

router = APIRouter(tags=["health"])


@router.get("/health")
def health():
    """Periksa API dan koneksi MySQL."""
    waktu = datetime.now().isoformat(timespec="seconds")
    try:
        with engine.connect() as connection:
            versi = connection.execute(text("SELECT VERSION()")).scalar_one()
    except Exception as error:
        raise HTTPException(
            status_code=503,
            detail={
                "status": "error",
                "waktu_server": waktu,
                "database": "error",
                "pesan": str(error),
            },
        ) from error
    return {
        "status": "ok",
        "waktu_server": waktu,
        "database": "ok",
        "mysql_version": versi,
    }
