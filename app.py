from flask import Flask, render_template, request, abort
from flask_cors import CORS
from tempfile import NamedTemporaryFile
import whisper
import torch

# Check if NVIDIA GPU is available
torch.cuda.is_available()
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"

# Load the Whisper model:
model = whisper.load_model("medium")

app = Flask(__name__)
CORS(app)

@app.route('/whisperapp', methods=['POST'])
def handler():
    if not request.files:
        abort(400)

    results = []

    for filename, handle in request.files.items():
        temp = NamedTemporaryFile()
        handle.save(temp)

        result = model.transcribe(temp.name)

        results.append({
            'filename': filename,
            'transcript': result.text,
        })

    return render_template('index.html', results=results)

if __name__ == '__main__':
    app.run()
