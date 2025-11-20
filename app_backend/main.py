from fastapi import FastAPI
from api.learning import router as learning_router

app = FastAPI(title="ShadowLearn API v1")
app.include_router(learning_router)

@app.get("/")
def root():
    return {"status": "ShadowLearn Backend läuft"}
