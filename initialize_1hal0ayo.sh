
#!/bin/bash

# Set project variables
PROJECT_NAME="youtube_openai_integration"
PYTHON_VERSION="python3" # Adjust if needed (e.g., python3.9)
ENCRYPTION_PASSWORD="your_encryption_password" # Change to your desired encryption password

# Create project directory and navigate into it
echo "Creating project directory: $PROJECT_NAME..."
mkdir $PROJECT_NAME && cd $PROJECT_NAME

# Initialize Git repository
echo "Initializing Git repository..."
git init

# Create the main project structure
echo "Creating project structure..."
mkdir -p config venv
touch main.py requirements.txt .gitignore README.md config/config.yaml

# Write the main.py file content
echo "Creating main.py file..."
cat <<EOL > main.py
from fastapi import FastAPI, HTTPException
import requests
import openai

app = FastAPI()

# Load API keys from config file
import yaml
with open('config/config.yaml', 'r') as file:
    config = yaml.safe_load(file)
YOUTUBE_API_KEY = config['YOUTUBE_API_KEY']
OPENAI_API_KEY = config['OPENAI_API_KEY']
openai.api_key = OPENAI_API_KEY

def get_youtube_data(query):
    url = f"https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q={query}&key={YOUTUBE_API_KEY}"
    response = requests.get(url)
    if response.status_code != 200:
        raise HTTPException(status_code=400, detail="Error fetching YouTube data")
    return response.json()

@app.get("/youtube/{query}")
async def search_youtube(query: str):
    data = get_youtube_data(query)
    return data

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
EOL

# Write requirements.txt
echo "Creating requirements.txt..."
cat <<EOL > requirements.txt
fastapi
uvicorn
requests
openai
pyyaml
EOL

# Write .gitignore
echo "Creating .gitignore..."
cat <<EOL > .gitignore
venv/
__pycache__/
*.pyc
*.pyo
config/config.yaml
config/config.yaml.enc
EOL

# Write README.md
echo "Creating README.md..."
cat <<EOL > README.md
# YouTube and OpenAI Integration API

This project provides an API that fetches data from YouTube and processes OpenAI completions.

## Setup

1. Clone the repository.
2. Create a virtual environment:
   \`\`\`
   python -m venv venv
   \`\`\`
3. Activate the virtual environment and install dependencies:
   \`\`\`
   pip install -r requirements.txt
   \`\`\`
4. Set your API keys in \`config/config.yaml\`.

## Running the Application

Start the FastAPI server:
\`\`\`
uvicorn main:app --reload
\`\`\`
Access the API at \`http://localhost:8000\`.
EOL

# Set up the Python virtual environment
echo "Setting up Python virtual environment..."
$PYTHON_VERSION -m venv venv
source venv/bin/activate

# Install required dependencies
echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Prompt user to input API keys and store them in config.yaml
echo "Creating config.yaml file..."
read -sp "Enter your YouTube API Key: " YOUTUBE_API_KEY
echo
read -sp "Enter your OpenAI API Key: " OPENAI_API_KEY
echo

cat <<EOL > config/config.yaml
YOUTUBE_API_KEY: "$YOUTUBE_API_KEY"
OPENAI_API_KEY: "$OPENAI_API_KEY"
EOL

# Encrypt the config.yaml file using OpenSSL
echo "Encrypting config.yaml..."
openssl enc -aes-256-cbc -salt -in config/config.yaml -out config/config.yaml.enc -k "$ENCRYPTION_PASSWORD"
rm config/config.yaml

# Generate SSH keys for secure access if not already present
echo "Generating SSH keys..."
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi

# Display the SSH public key for GitHub or server access
echo "Your SSH public key is:"
cat ~/.ssh/id_rsa.pub

# Completion message
echo "Project setup completed successfully. Your project is now ready."
echo "To start the FastAPI server, activate the virtual environment with 'source venv/bin/activate' and run 'uvicorn main:app --reload'"
