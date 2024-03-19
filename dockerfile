FROM python:3.10-slim-buster

WORKDIR ./src

COPY ./analytics .

RUN pip install --upgrade pip && pip install -r requirements.txt

ENTRYPOINT ["python", "app.py"]
