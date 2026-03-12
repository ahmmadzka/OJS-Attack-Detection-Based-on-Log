-- skrip inisialisasi postgresql proyek ojs ids
-- berjalan otomatis saat container start

-- pastikan database tersedia dibuat via postgres db env var

-- aktifkan pg trgm untuk pencarian teks analisis log
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- verifikasi database udah siap
SELECT current_database(), current_user, version();
