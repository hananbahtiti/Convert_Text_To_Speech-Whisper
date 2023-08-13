FROM python:3.10-slim

WORKDIR ~/whisperapp

COPY requirements.txt requirements.txt

ENV PIP_ROOT_USER_ACTION=ignore

RUN apt-get update && apt-get install git -y
RUN pip install --upgrade pip
#RUN pip3 install --upgrade Jinja2==3.0.3
#RUN pip install itsdangerous==2.0.1
#RUN pip install Werkzeug==2.0.3
#RUN pip install MarkupSafe==2.0.1
RUN pip install Flask
RUN pip3 install -r requirements.txt
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
RUN pip3 install "git+https://github.com/openai/whisper.git"
RUN apt-get install -y ffmpeg

COPY . .

EXPOSE 5000

CMD ["python3", "-m" , "flask", "run", "--host=0.0.0.0", "port=5000"]


