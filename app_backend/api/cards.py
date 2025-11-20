from fastapi import APIRouter
router = APIRouter(prefix="/cards", tags=["Cards"])

@router.get("/aevo")
def aevo_cards():
    return {"cards": ["AEVO Karte 1", "AEVO Karte 2"]}
