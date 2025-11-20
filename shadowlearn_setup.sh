#!/usr/bin/env bash
set -e

BASE="/home/schattenmacher/development/ShadowLearn"
cd "$BASE"

echo "[1/10] Erzeuge Flutter-Struktur …"
mkdir -p app_frontend/lib/{ui,widgets,services,styles}
mkdir -p app_frontend/assets/icons

cat > app_frontend/pubspec.yaml << 'EOFX'
name: shadowlearn
description: ShadowLearn – Strategisches Lernsystem v1
environment:
  sdk: ">=3.3.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  provider: ^6.0.5
flutter:
  uses-material-design: true
  assets:
    - assets/icons/
EOFX

cat > app_frontend/lib/main.dart << 'EOFX'
import 'package:flutter/material.dart';
import 'ui/dashboard.dart';

void main() => runApp(const ShadowLearn());

class ShadowLearn extends StatelessWidget {
  const ShadowLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ShadowLearn",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Inter",
      ),
      home: Dashboard(),
    );
  }
}
EOFX

cat > app_frontend/lib/ui/dashboard.dart << 'EOFX'
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ShadowLearn Dashboard")),
      body: const Center(
        child: Text("ShadowLearn – Lernsystem aktiv", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
EOFX

echo "[2/10] Erzeuge FastAPI Backend …"
mkdir -p app_backend/{api,core}

cat > app_backend/main.py << 'EOFX'
from fastapi import FastAPI
from api.learning import router as learning_router

app = FastAPI(title="ShadowLearn API v1")
app.include_router(learning_router)

@app.get("/")
def root():
    return {"status": "ShadowLearn Backend läuft"}
EOFX

cat > app_backend/api/learning.py << 'EOFX'
from fastapi import APIRouter
router = APIRouter(prefix="/learning", tags=["Learning"])

@router.get("/model")
def model():
    return {
        "model": "Struktur → Aktion → Visualisierung → Wiederholung"
    }
EOFX

cat > app_backend/requirements.txt << 'EOFX'
fastapi
uvicorn
sqlalchemy
EOFX

mkdir -p data
touch data/shadowlearn.db

echo "[3/10] README erzeugen …"
cat > README.md << 'EOFX'
# ShadowLearn – Strategisches Lernsystem v1

Frontend: Flutter  
Backend: FastAPI  
Lernengine: ShadowFlow

## Backend starten
cd app_backend  
uvicorn main:app --reload

## Frontend starten
cd app_frontend  
flutter pub get  
flutter run
EOFX

echo "[4/10] Git Push …"
git add .
git commit -m "ShadowLearn Fullstack Setup"
git push -u origin main --force

echo "ShadowLearn Setup vollständig abgeschlossen."
