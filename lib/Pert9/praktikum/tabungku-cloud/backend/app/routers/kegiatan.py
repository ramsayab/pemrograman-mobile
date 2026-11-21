from datetime import date
from typing import Literal

from fastapi import APIRouter, Depends, HTTPException, Query, Response, status
from fastapi.exceptions import RequestValidationError
from pydantic import ValidationError
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import Kegiatan, Tipe
from ..schemas import KegiatanInput, KegiatanOut, KegiatanPatch

router = APIRouter(prefix="/kegiatan", tags=["kegiatan"])


def _ambil_atau_404(db: Session, kegiatan_id: int) -> Kegiatan:
    kegiatan = db.get(Kegiatan, kegiatan_id)
    if kegiatan is None:
        raise HTTPException(status_code=404, detail="Kegiatan tidak ditemukan")
    return kegiatan


@router.get("", response_model=list[KegiatanOut])
def daftar_kegiatan(
    response: Response,
    tanggal: date | None = None,
    tipe: Tipe | None = None,
    selesai: bool | None = None,
    urut: Literal["terbaru", "terlama"] = "terbaru",
    q: str | None = Query(None, description="Cari di judul"),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db),
):
    stmt = select(Kegiatan)
    if tanggal is not None:
        stmt = stmt.where(Kegiatan.tanggal == tanggal)
    if tipe is not None:
        stmt = stmt.where(Kegiatan.tipe == tipe)
    if selesai is not None:
        stmt = stmt.where(Kegiatan.selesai == selesai)
    if q:
        stmt = stmt.where(Kegiatan.judul.contains(q))

    total = db.scalar(select(func.count()).select_from(stmt.subquery())) or 0
    response.headers["X-Total-Count"] = str(total)
    arah_tanggal = Kegiatan.tanggal.desc() if urut == "terbaru" else Kegiatan.tanggal.asc()
    arah_id = Kegiatan.id.desc() if urut == "terbaru" else Kegiatan.id.asc()
    stmt = stmt.order_by(arah_tanggal, Kegiatan.selesai, arah_id).limit(limit).offset(offset)
    return db.scalars(stmt).all()


@router.get("/{kegiatan_id}", response_model=KegiatanOut)
def detail_kegiatan(kegiatan_id: int, db: Session = Depends(get_db)):
    return _ambil_atau_404(db, kegiatan_id)


@router.post("", response_model=KegiatanOut, status_code=status.HTTP_201_CREATED)
def tambah_kegiatan(data: KegiatanInput, db: Session = Depends(get_db)):
    kegiatan = Kegiatan(**data.model_dump())
    db.add(kegiatan)
    db.commit()
    db.refresh(kegiatan)
    return kegiatan


@router.put("/{kegiatan_id}", response_model=KegiatanOut)
def ubah_kegiatan(kegiatan_id: int, data: KegiatanInput, db: Session = Depends(get_db)):
    kegiatan = _ambil_atau_404(db, kegiatan_id)
    for kolom, nilai in data.model_dump().items():
        setattr(kegiatan, kolom, nilai)
    db.commit()
    db.refresh(kegiatan)
    return kegiatan


@router.patch("/{kegiatan_id}", response_model=KegiatanOut)
def ubah_sebagian(
    kegiatan_id: int,
    data: KegiatanPatch,
    db: Session = Depends(get_db),
):
    kegiatan = _ambil_atau_404(db, kegiatan_id)
    gabungan = KegiatanOut.model_validate(kegiatan).model_dump()
    gabungan.update(data.model_dump(exclude_unset=True))
    try:
        valid = KegiatanInput.model_validate(gabungan)
    except ValidationError as error:
        errors = error.errors(include_url=False, include_context=False)
        for item in errors:
            if not item["loc"] or item["loc"][0] != "body":
                item["loc"] = ("body", *item["loc"])
        raise RequestValidationError(errors, body=data.model_dump(exclude_unset=True)) from error
    for kolom, nilai in valid.model_dump().items():
        setattr(kegiatan, kolom, nilai)
    db.commit()
    db.refresh(kegiatan)
    return kegiatan


@router.delete("/{kegiatan_id}", status_code=status.HTTP_204_NO_CONTENT)
def hapus_kegiatan(kegiatan_id: int, db: Session = Depends(get_db)) -> Response:
    db.delete(_ambil_atau_404(db, kegiatan_id))
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)
