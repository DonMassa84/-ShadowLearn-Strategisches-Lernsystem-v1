#!/usr/bin/env bash

# =======================================================
#   SHADOWLEARN DEV-DASHBOARD (TUI) – v1
# =======================================================

BACKEND_DIR="$HOME/development/ShadowLearn/app_backend"
FRONTEND_DIR="$HOME/development/ShadowLearn/app_frontend"
VENV="$BACKEND_DIR/venv"
LOG_DIR="$HOME/development/ShadowLearn/logs"
PORT=8000

mkdir -p "$LOG_DIR"

# -------------------------
# Utility
# -------------------------
get_backend_pid() {
    ps aux | grep "uvicorn main:app" | grep -v grep | awk '{print $2}'
}

get_frontend_pid() {
    ps aux | grep "flutter run" | grep -v grep | awk '{print $2}'
}

kill_port() {
    PID=$(sudo lsof -t -i:$PORT)
    if [ -n "$PID" ]; then
        sudo kill -9 "$PID"
    fi
}

start_backend() {
    echo "Starte Backend ..."
    kill_port
    cd "$BACKEND_DIR" || return
    source "$VENV/bin/activate"
    uvicorn main:app --reload --port $PORT \
        > "$LOG_DIR/backend.log" 2>&1 &
    sleep 1
}

stop_backend() {
    PID=$(get_backend_pid)
    if [ -n "$PID" ]; then
        kill -9 "$PID"
    fi
}

start_frontend() {
    cd "$FRONTEND_DIR" || return
    flutter pub get > /dev/null
    flutter run -d chrome \
        > "$LOG_DIR/frontend.log" 2>&1 &
    sleep 1
}

stop_frontend() {
    PID=$(get_frontend_pid)
    if [ -n "$PID" ]; then
        kill -9 "$PID"
    fi
}

show_status() {
    clear
    echo "=============================================================="
    echo "                 SHADOWLEARN – DEV DASHBOARD"
    echo "=============================================================="
    echo
    echo "Backend: "
    BPID=$(get_backend_pid)
    if [ -n "$BPID" ]; then
        echo "   ✔ Running (PID: $BPID)"
    else
        echo "   ✘ Stopped"
    fi
    echo
    echo "Frontend:"
    FPID=$(get_frontend_pid)
    if [ -n "$FPID" ]; then
        echo "   ✔ Running (PID: $FPID)"
    else
        echo "   ✘ Stopped"
    fi
    echo
    echo "--------------------------------------------------------------"
    echo "[1] Backend starten"
    echo "[2] Backend stoppen"
    echo "[3] Backend-Logs ansehen"
    echo "[4] Frontend starten"
    echo "[5] Frontend stoppen"
    echo "[6] Frontend-Logs ansehen"
    echo "--------------------------------------------------------------"
    echo "[7] Port 8000 killen"
    echo "[8] Systemstatus (htop ähnlich)"
    echo "[9] Health-Check"
    echo "[0] Dashboard verlassen"
    echo
    echo "Auswahl: "
}

system_info() {
    clear
    echo "==================== SYSTEMSTATUS ===================="
    echo
    echo "($(date))"
    echo
    echo "CPU:"
    mpstat 1 1 | tail -1
    echo
    echo "RAM:"
    free -h
    echo
    echo "Prozesse ShadowLearn:"
    ps aux | grep -E "uvicorn|flutter run" | grep -v grep
    echo
    echo "------------------------------------------------------"
    read -p "Zurück (Enter)"
}

health_check() {
    clear
    echo "==================== HEALTH CHECK ===================="
    echo
    echo "Backend:"
    curl -s http://127.0.0.1:$PORT || echo "✘ Keine Antwort"
    echo
    echo "------------------------------------------------------"
    read -p "Zurück (Enter)"
}

# -------------------------
# MAIN LOOP
# -------------------------

while true; do
    show_status
    read -r choice

    case "$choice" in
    1) start_backend ;;
    2) stop_backend ;;
    3) less +F "$LOG_DIR/backend.log" ;;
    4) start_frontend ;;
    5) stop_frontend ;;
    6) less +F "$LOG_DIR/frontend.log" ;;
    7) kill_port ;;
    8) system_info ;;
    9) health_check ;;
    0) clear; exit 0 ;;
    *) echo "Ungültige Auswahl" ;;
    esac
done
