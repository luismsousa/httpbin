FROM python:3.9-slim

LABEL name="httpbin"
LABEL version="0.9.2"
LABEL description="A simple HTTP service."
LABEL org.kennethreitz.vendor="Kenneth Reitz"

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Install system dependencies including build tools
RUN apt-get -y update && apt-get -y install \
    libffi-dev \
    libssl-dev \
    git \
    gcc \
    g++ \
    make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /httpbin

# Install dependencies directly with pip3
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    pip3 install --no-cache-dir \
    pycparser \
    gunicorn \
    decorator \
    brotlipy \
    gevent \
    "Flask<2.3.0" \
    meinheld \
    "werkzeug<2.0.0" \
    "markupsafe<2.1.0" \
    "jinja2<3.1.0" \
    six \
    flasgger \
    pyyaml

ADD . /httpbin
RUN pip3 install --no-cache-dir /httpbin

EXPOSE 80

CMD ["gunicorn", "-b", "0.0.0.0:80", "httpbin:app", "-k", "gevent"]