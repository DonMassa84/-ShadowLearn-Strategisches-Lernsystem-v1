from fastapi import APIRouter
router = APIRouter(prefix="/learning", tags=["Learning"])

@router.get("/model")
def model():
    return {
        "model": "Struktur → Aktion → Visualisierung → Wiederholung"
    }
