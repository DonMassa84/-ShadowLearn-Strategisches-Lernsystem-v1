from fastapi import APIRouter
router = APIRouter(prefix="/flow", tags=["Flow"])

@router.get("/diagram")
def flow_diagram():
    return {"diagram": "ShadowFlow Prozessdiagramm"}
