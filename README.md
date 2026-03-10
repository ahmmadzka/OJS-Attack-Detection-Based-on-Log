# OJS Log-Based Intrusion Detection System

Sistem klasifikasi serangan pada website berbasis OJS menggunakan Machine Learning untuk mendeteksi anomali dan pola serangan secara real-time.

## Architecture

```
Client ──► NGINX (reverse proxy + mirror)
              │                │
              ▼                ▼
            OJS          Traffic Extractor
              │                │
              ▼                ▼
          PostgreSQL      ML Service ──► Telegram Alert
```

## Components

| Service | Description | Port |
|---------|-------------|------|
| **NGINX** | Reverse proxy + traffic mirroring ke extractor | `80` (host) |
| **OJS** | Open Journal Systems platform | internal |
| **PostgreSQL** | Database untuk OJS | internal |
| **Extractor** | Traffic log extractor (Go/Gin) diclone dari [`yogarn/traffic-extractor`](https://github.com/yogarn/traffic-extractor) | `8080` (host) → `8081` (container) |
| **ML Service** | ML inference API — *belum aktif, uncomment di `docker-compose.yml` saat siap* | `5000` |

> **Catatan Port Extractor:** `docker-compose.yml` memetakan port host `8080` ke port container `8081`. Nginx di `mirror.conf` sudah dikonfigurasi memanggil `http://extractor:8081` (port container). Pastikan repo `yogarn/traffic-extractor` memang listen di port **8081**.

## Project Structure

```
ojs-ids-project/
├── docker-compose.yml
├── .env.example
├── nginx/
│   ├── nginx.conf
│   ├── mirror.conf
│   └── logs/
├── ojs/
│   └── Dockerfile
├── postgres/
│   └── init.sql
├── extractor/          ← diclone saat setup.sh
├── dataset/
│   ├── raw_logs/
│   ├── processed/
│   └── export/
└── scripts/
    └── setup.sh

```

## Integrating ML Service

Setelah model ML siap:
1. Tambahkan folder `ml-service/` di root project
2. Uncomment blok `ml-service` di `docker-compose.yml`
3. Isi `TELEGRAM_BOT_TOKEN` dan `TELEGRAM_CHAT_ID` di `.env`
4. Jalankan ulang: `docker compose up -d --build`