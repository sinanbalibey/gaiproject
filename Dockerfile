FROM python:3.9-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN pip install sentencepiece

RUN pip install --no-cache-dir jupyter transformers torch

RUN pip install googletrans==4.0.0-rc1

WORKDIR /home/jovyan/work

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=iamironman"]
