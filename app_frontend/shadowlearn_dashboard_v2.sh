#!/usr/bin/env bash

# =======================================================
#   SHADOWLEARN DEV-DASHBOARD (TUI v2)
#       ASCII • Farben • Maus • Monitoring • Watchdog
# =======================================================

BACKEND_DIR="$HOME/development/ShadowLearn/app_backend"
FRONTEND_DIR="$HOME/development/ShadowLearn/app_frontend"
VENV="$BACKEND_DIR/venv"
LOG_DIR="$HOME/development/ShadowLearn/logs"
PORT=8000

mkdir -p "$LOG_DIR"

# -------------------------
#  COLOR SCHEME (ShadowMaker)
# -------------------------
ORANGE="\e[38;5[202m]"
GRAY="\e[38;5[240m]"
WHITE="\e[97m"
BLACK="\e[30m"
RESET="\e[0m"

# -------------------------
#  ASCII LOGO
# -------------------------
shadowlogo() {
clear
echo -e "${ORANGE}"
cat << 'LOGO'
███████╗██╗  ██╗ █████╗ ██████╗ ██████╗  ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗██╔══██╗██╔═══██╗██║     ██╔════╝██╔══██╗████╗  ██║
███████╗███████║███████║██████╔╝██████╔╝██║   ██║██║     █████╗  ███████║██╔██╗ ██║
╚════██║██╔══██║██╔══██║██╔══██╗██╔══██╗██║   ██║██║     ██╔══╝  ██╔══██║██║╚██╗██║
███████║██║  ██║██║  ██║██║  ██║██║  ██║╚██████╔╝███████╗███████╗██║  ██║██║ ╚████║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝
LOGO
echo -e "${RESET}"
}

# -------------------------
# Fetch PIDs
# -------------------------
get_backend_pid() {
    ps aux | grep "uvicorn main:app" | grep -v grep | awk '{print $2}'
}

get_frontend_pid() {
    ps aux | grep "flutter run" | grep -v grep | awk '{print $2}'
}

# -------------------------
# Monitoring Infos
# -------------------------
monitor_backend() {
    PID=$(get_backend_pid)
    if [ -z "$PID" ]; then
        echo "Backend: ✘ Offline"
        return
    fi

    CPU=$(ps -p $PID -o %cpu --no-headers)
    MEM=$(ps -p $PID -o %mem --no-headers)

    echo "Backend PID: $PID"
    echo "CPU: $CPU%"
    echo "RAM: $MEM%"
    sudo lsof -i :$PORT | grep LISTEN
}

monitor_frontend() {
    PID=$(get_frontend_pid)
    if [ -z "$PID" ]; then
        echo "Frontend: ✘ Offline"
        return
    fi

    CPU=$(ps -p $PID -o %cpu --no-headers)
    MEM=$(ps -p $PID -o %mem --no-headers)

    echo "Frontend PID: $PID"
    echo "CPU: $CPU%"
    echo "RAM: $MEM%"
}

# -------------------------
# Watchdog Engine
# -------------------------
watchdog_loop() {
while true; do
    BP=$(get_backend_pid)
    FP=$(get_frontend_pid)

    if [ -z "$BP" ]; then
        echo "Watchdog: Backend DOWN – restarting..."
        start_backend
    fi

    if [ -z "$FP" ]; then
        echo "Watchdog: Frontend DOWN – restarting..."
        start_frontend
    fi

    sleep 5
done
}

# -------------------------
# Start / Stop functions
# -------------------------
start_backend() {
    kill_port
    cd "$BACKEND_DIR" || return
    source "$VENV/bin/activate"
    uvicorn main:app --reload --port $PORT > "$LOG_DIR/backend.log" 2>&1 &
}

stop_backend() {
    PID=$(get_backend_pid)
    [ -n "$PID" ] && kill -9 "$PID"
}

start_frontend() {
    cd "$FRONTEND_DIR" || return
    flutter run -d chrome > "$LOG_DIR/frontend.log" 2>&1 &
}

stop_frontend() {
    PID=$(get_frontend_pid)
    [ -n "$PID" ] && kill -9 "$PID"
}

kill_port() {
    PID=$(sudo lsof -t -i:$PORT)
    [ -n "$PID" ] && sudo kill -9 $PID
}

# -------------------------
# MAIN FZF MENU
# -------------------------

while true; do
shadowlogo

CHOICE=$(printf "🚀 Backend starten\n🛑 Backend stoppen\n📄 Backend Logs\n📊 Backend Monitoring\n🌐 Frontend starten\n❌ Frontend stoppen\n📄 Frontend Logs\n📊 Frontend Monitoring\n⚡ Port 8000 killen\n🛡️ Watchdog starten\n🔧 System-Info\n🚪 Beenden\n" | 
    fzf --reverse --height=70% --border --ansi --prompt="ShadowLearn Dashboard > " 
)

case "$CHOICE" in
    "🚀 Backend starten") start_backend ;;
    "🛑 Backend stoppen") stop_backend ;;
    "📄 Backend Logs") less +F "$LOG_DIR/backend.log" ;;
    "📊 Backend Monitoring") clear; monitor_backend; read -p "ENTER" ;;
    "🌐 Frontend starten") start_frontend ;;
    "❌ Frontend stoppen") stop_frontend ;;
    "📄 Frontend Logs") less +F "$LOG_DIR/frontend.log" ;;
    "📊 Frontend Monitoring") clear; monitor_frontend; read -p "ENTER" ;;
    "⚡ Port 8000 killen") kill_port ;;
    "🛡️ Watchdog starten") watchdog_loop ;;
    "🔧 System-Info") clear; htop ;;
    "🚪 Beenden") clear; exit 0 ;;
esac

done

