FROM pytorch/pytorch:latest
RUN apt-get update 
RUN apt-get install -y \
    gcc \
    git \
    libgtk2.0-dev \
    wget \
    apt-utils
RUN wget https://github.com/QIICR/dcmqi/releases/download/v1.2.2/dcmqi-1.2.2-linux.tar.gz
RUN tar -zxvf dcmqi-1.2.2-linux.tar.gz && rm dcmqi-1.2.2-linux.tar.gz
RUN mkdir input
RUN mkdir output
COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt
COPY . /app
