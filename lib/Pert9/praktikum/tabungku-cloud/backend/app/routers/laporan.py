from datetime import date, timedelta

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import case, func, select
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import Kegiatan, Tipe
from ..schemas import LaporanHarianOut, LaporanRentangOut

router = APIRouter(prefix="/laporan", tags=["laporan"])


def _ringkasan_select():
    pemasukan = func.coalesce(
        func.sum(case((Kegiatan.tipe == Tipe.pemasukan, Kegiatan.nominal), else_=0)), 0
    )
    pengeluaran = func.coalesce(
        func.sum(case((Kegiatan.tipe == Tipe.pengeluaran, Kegiatan.nominal), else_=0)), 0
    )
    selesai = func.coalesce(
        func.sum(case((Kegiatan.selesai.is_(True), 1), else_=0)), 0
    )
    return pemasukan.label("pemasukan"), pengeluaran.label("pengeluaran"), selesai.label("selesai")


@router.get("/harian", response_model=LaporanHarianOut)
def laporan_harian(
    tanggal: date = Query(..., description="Tanggal laporan, format YYYY-MM-DD"),
    db: Session = Depends(get_db),
):
    pemasukan_expr, pengeluaran_expr, selesai_expr = _ringkasan_select()
    row = db.execute(
        select(
            func.count(Kegiatan.id).label("jumlah_kegiatan"),
            selesai_expr,
            pemasukan_expr,
            pengeluaran_expr,
        ).where(Kegiatan.tanggal == tanggal)
    ).mappings().one()

    kategori_rows = db.execute(
        select(
            Kegiatan.kategori.label("kategori"),
            func.coalesce(func.sum(Kegiatan.nominal), 0).label("total"),
        )
        .where(
            Kegiatan.tanggal == tanggal,
            Kegiatan.tipe == Tipe.pengeluaran,
        )
        .group_by(Kegiatan.kategori)
        .order_by(func.sum(Kegiatan.nominal).desc(), Kegiatan.kategori.asc())
    ).mappings().all()

    total_pemasukan = int(row["pemasukan"])
    total_pengeluaran = int(row["pengeluaran"])
    return {
        "tanggal": tanggal,
        "jumlah_kegiatan": int(row["jumlah_kegiatan"]),
        "selesai": int(row["selesai"]),
        "pemasukan": total_pemasukan,
        "pengeluaran": total_pengeluaran,
        "tabungan": total_pemasukan - total_pengeluaran,
        "per_kategori": [dict(item) for item in kategori_rows],
    }


@router.get("/rentang", response_model=LaporanRentangOut)
def laporan_rentang(
    mulai: date = Query(..., description="Tanggal awal, format YYYY-MM-DD"),
    sampai: date = Query(..., description="Tanggal akhir, format YYYY-MM-DD"),
    db: Session = Depends(get_db),
):
    jumlah_hari = (sampai - mulai).days + 1
    if jumlah_hari <= 0:
        raise HTTPException(status_code=400, detail="Tanggal mulai harus sebelum atau sama dengan tanggal akhir")
    if jumlah_hari > 31:
        raise HTTPException(status_code=400, detail="Rentang laporan maksimal 31 hari")

    pemasukan_expr, pengeluaran_expr, selesai_expr = _ringkasan_select()
    rows = db.execute(
        select(
            Kegiatan.tanggal.label("tanggal"),
            func.count(Kegiatan.id).label("jumlah_kegiatan"),
            selesai_expr,
            pemasukan_expr,
            pengeluaran_expr,
        )
        .where(Kegiatan.tanggal.between(mulai, sampai))
        .group_by(Kegiatan.tanggal)
        .order_by(Kegiatan.tanggal)
    ).mappings().all()

    per_tanggal = {row["tanggal"]: row for row in rows}
    harian = []
    for indeks in range(jumlah_hari):
        tanggal = mulai + timedelta(days=indeks)
        row = per_tanggal.get(tanggal)
        pemasukan = int(row["pemasukan"]) if row else 0
        pengeluaran = int(row["pengeluaran"]) if row else 0
        harian.append({
            "tanggal": tanggal,
            "jumlah_kegiatan": int(row["jumlah_kegiatan"]) if row else 0,
            "selesai": int(row["selesai"]) if row else 0,
            "pemasukan": pemasukan,
            "pengeluaran": pengeluaran,
            "tabungan": pemasukan - pengeluaran,
        })

    return {"mulai": mulai, "sampai": sampai, "harian": harian}
