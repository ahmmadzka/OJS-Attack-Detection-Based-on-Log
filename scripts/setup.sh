#!/bin/bash
set -e

cd "$(dirname "$0")/.." || exit 1

echo "Setup project"

CONFIG_FILE="./ojs/config.inc.php"

# detect first run
if [ ! -f "$CONFIG_FILE" ]; then
    FIRST_RUN=true
    echo "First run"
else
    FIRST_RUN=false
    echo "Existing setup"
fi

# stop container (non destructive)
docker compose down 2>/dev/null || true

# clone extractor if not exist
if [ ! -d "extractor/.git" ]; then
    git clone https://github.com/yogarn/traffic-extractor.git extractor/
    cp scripts/extractor.Dockerfile extractor/Dockerfile
fi

# env setup
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo "Edit .env first"
    read -p "Press ENTER after editing..." _
fi

# prepare directories
mkdir -p nginx/logs
touch extractor/requests.log

# start containers
if [ "$FIRST_RUN" = true ]; then
    docker compose up -d --build
else
    docker compose up -d
fi

# first run logic
if [ "$FIRST_RUN" = true ]; then
    echo "Open http://localhost and finish OJS installation"
    read -p "Press ENTER after install done..." _

    echo "Waiting for container..."
    until docker exec ojs-app ls /var/www/html >/dev/null 2>&1; do
        sleep 2
    done

    echo "Copy config"
    docker cp ojs-app:/var/www/html/config.inc.php "$CONFIG_FILE"

    echo "Restart with persistent config"
    docker compose down
    docker compose up -d

    echo "Setup complete (persistent mode active)"
else
    echo "Already configured"
fi