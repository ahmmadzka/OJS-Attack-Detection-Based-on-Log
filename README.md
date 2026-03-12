## arsitektur

```
Client ──► NGINX (reverse proxy + mirror)
              │                │
              ▼                ▼
            OJS          Traffic Extractor
              │                │
              ▼                ▼
          PostgreSQL      ML Service ──► Telegram Alert
```

## komponen

| Service | Description | Port |
|---------|-------------|------|
| **NGINX** | Reverse proxy + traffic mirroring ke extractor | `80` (host) |
| **OJS** | Open Journal Systems platform | internal |
| **PostgreSQL** | Database untuk OJS | internal |
| **Extractor** | Traffic log extractor (Go/Gin) diclone dari [`yogarn/traffic-extractor`](https://github.com/yogarn/traffic-extractor) | `8080` (host) → `8081` (container) |
| **ML Service** | ML inference API — *not yet active*, uncomment di `docker-compose.yml` | `5000` |

> **daftar port extractor:** `docker-compose.yml`, port host `8080` ke port container `8081`. Nginx di `mirror.conf` udah dikonfigurasi memanggil `http://extractor:8081` (port container). Traffic log extractor (Go/Gin) dari repo `yogarn/traffic-extractor` akan listen di port **8081**.

## struktur projek

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
OTW