from fastapi import APIRouter
router = APIRouter(prefix="/pruefung", tags=["Prüfung"])

@router.get("/simulation")
def pruefung_sim():
    return {"task": "IHK Prüfungssimulation 90+ Punkte Mode"}
