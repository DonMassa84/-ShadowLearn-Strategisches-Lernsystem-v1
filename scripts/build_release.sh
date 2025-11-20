#!/usr/bin/env bash
set -e

echo "====== ShadowLearn Release Builder v1.0 ======"

BASE="$HOME/development/ShadowLearn"
REL="$BASE/release"
mkdir -p "$REL"

# === 1. Backend Build ===
echo "[1/5] Erzeuge Backend-Release …"
mkdir -p "$REL/backend"
cp -r "$BASE/app_backend" "$REL/backend"

# === 2. Frontend Build ===
echo "[2/5] Erzeuge Flutter Webbuild …"
mkdir -p "$REL/frontend"
cd "$BASE/app_frontend"
flutter build web
cp -r build/web "$REL/frontend"

# === 3. Docker Build ===
echo "[3/5] Kopiere Docker-Konfiguration …"
mkdir -p "$REL/docker"
cp "$BASE/docker-compose.yml" "$REL/docker/"

# === 4. ZIP Build ===
echo "[4/5] Erzeuge ZIP …"
cd "$REL"
zip -r shadowlearn_v1.0.zip .

# === 5. Git Tag ===
cd "$BASE"
git add .
git commit -m "Release ShadowLearn v1.0"
git tag -a "v1.0" -m "ShadowLearn Release v1.0"
git push origin main --tags

echo "====== Release erfolgreich erstellt ======"
echo "Datei: $REL/shadowlearn_v1.0.zip"
