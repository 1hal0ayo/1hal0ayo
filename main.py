# main.py
from fastapi import FastAPI, HTTPException
import requests
import openai
import yaml
from quark import encrypt_data, decrypt_data

app = FastAPI()

# Load API keys from config file
with open('config/config.yaml', 'r') as file:
    config = yaml.safe_load(file)

YOUTUBE_API_KEY = config['YOUTUBE_API_KEY']
OPENAI_API_KEY = config['OPENAI_API_KEY']
SECRET_KEY = config['SECRET_KEY']  # Your secret key for encryption

openai.api_key = OPENAI_API_KEY

@app.get("/youtube/{query}")
async def search_youtube(query: str):
    url = f"https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q={query}&key={YOUTUBE_API_KEY}"
    response = requests.get(url)
    if response.status_code != 200:
        raise HTTPException(status_code=400, detail="Error fetching YouTube data")
    return response.json()

@app.post("/process-openai")
async def process_openai(data: dict):
    prompt = data.get("prompt", "")
    try:
        response = openai.Completion.create(
            engine="text-davinci-004",
            prompt=prompt,
            max_tokens=100
        )
        return {"result": response.choices[0].text.strip()}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/encrypt")
async def encrypt(data: str):
    encrypted_data = encrypt_data(data, SECRET_KEY)
    return {"encrypted_data": encrypted_data.decode()}

@app.post("/decrypt")
async def decrypt(encrypted_data: str):
    try:
        decrypted_data = decrypt_data(encrypted_data.encode(), SECRET_KEY)
        return {"decrypted_data": decrypted_data}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
      
