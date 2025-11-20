#!/usr/bin/env bash

# ===============================================
#   SHADOWLEARN – FULLSTACK STARTSCRIPT v1
# ===============================================

BACKEND_DIR="$HOME/development/ShadowLearn/app_backend"
FRONTEND_DIR="$HOME/development/ShadowLearn/app_frontend"
VENV="$BACKEND_DIR/venv"
LOG_DIR="$HOME/development/ShadowLearn/logs"

mkdir -p "$LOG_DIR"

echo "==============================================="
echo "  ShadowLearn Fullstack Start"
echo "==============================================="

# -------------------------
# 1. Backend-Port freimachen
# -------------------------
echo "[1] Prüfe Port 8000 …"

PID=$(sudo lsof -t -i:8000)

if [ -n "$PID" ]; then
    echo "→ Port 8000 belegt durch PID $PID – beende Prozess …"
    sudo kill -9 "$PID"
else
    echo "→ Port 8000 ist frei."
fi

# -------------------------
# 2. Backend starten
# -------------------------
echo "[2] Starte Backend …"

cd "$BACKEND_DIR" || {
    echo "❌ Backend-Verzeichnis nicht gefunden!"
    exit 1
}

# venv aktivieren
source "$VENV/bin/activate"

# Backend starten
uvicorn main:app --reload --host 0.0.0.0 --port 8000 \
    > "$LOG_DIR/backend.log" 2>&1 &

BACKEND_PID=$!
echo "→ Backend gestartet (PID $BACKEND_PID)"
echo "→ API: http://127.0.0.1:8000/"
echo "→ Docs: http://127.0.0.1:8000/docs"

# -------------------------
# 3. Frontend starten
# -------------------------
echo "[3] Starte Flutter-Frontend …"

cd "$FRONTEND_DIR" || {
    echo "❌ Frontend-Verzeichnis nicht gefunden!"
    exit 1
}

# Dependencies
flutter pub get

# Flutter starten (Web)
flutter run -d chrome \
    > "$LOG_DIR/frontend.log" 2>&1 &

FRONTEND_PID=$!
echo "→ Frontend gestartet (PID $FRONTEND_PID)"
echo "→ Web-App öffnet sich automatisch."

# -------------------------
# 4. Übersicht
# -------------------------

echo "==============================================="
echo " ShadowLearn läuft!"
echo "-----------------------------------------------"
echo " Backend PID:   $BACKEND_PID"
echo " Frontend PID:  $FRONTEND_PID"
echo " Logs:          $LOG_DIR/"
echo "==============================================="

