# Simple server using FastApi which returns a json object.
# The json object is a dictionary with a key "message" and a value "Hello World".

from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello World"}
