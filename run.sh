GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

set -e

command -v python3 >/dev/null 2>&1 || { echo >&2 "Python3 is required but not installed.  Aborting."; exit 1; }
command -v virtualenv >/dev/null 2>&1 || { python3 -m pip install --user virtualenv; }

createPyFile() {
    echo -e "${YELLOW}🚀 Creating Python file${NC}"
    cat > app.py << EOL
import whisper

def transcribe_mp3(audio_file):
    try:
        model = whisper.load_model("base")  
        result = model.transcribe(audio_file)
        return result["text"]
    except Exception as e:
        print(f"Error during transcription: {e}")
        return None

if __name__ == "__main__":
    audio_file = "example.mp3" 
    transcript = transcribe_mp3(audio_file)

    if transcript:
        print("Transcription:")
        print(transcript)
        with open("transcript.txt", "w") as f:
            f.write(transcript)
        print("Transcript saved to transcript.txt")
    else:
        print("Transcription failed.")

EOL
}

gitignore() {
    echo -e "${YELLOW}♠︎ Generating .gitignore file${NC}"
    cat > .gitignore << EOL
.vscode
__pycache__
*.pyc
.venv
.env
logs/
EOL
}

main() {
    echo -e "${YELLOW}🔧 Audio Recognition Application Initialization${NC}"

    touch app.py .gitignore

    python3 -m venv .venv
    source .venv/bin/activate
    pip install --upgrade pip setuptools wheel
    pip install --upgrade pip
    brew install portaudio
    pip install speechrecognition pyaudio whisper
    gitignore
    createPyFile

    echo -e "${GREEN}🎉 Project is ready! Run 'python app.py' to start.${NC}"
}

main


