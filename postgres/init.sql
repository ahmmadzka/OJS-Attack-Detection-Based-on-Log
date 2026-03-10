-- Skrip inisialisasi PostgreSQL untuk Proyek OJS IDS
-- Skrip ini berjalan otomatis saat awal container dinyalakan

-- Pastikan database tersedia (dibuat via POSTGRES_DB env var)
-- Buat ekstensi tambahan jika diperlukan

-- Aktifkan pg_trgm untuk pencarian teks (berguna untuk analisis log)
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Verifikasi database sudah siap
SELECT current_database(), current_user, version();
