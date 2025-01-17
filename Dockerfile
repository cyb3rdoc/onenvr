FROM python:alpine

LABEL author="cyb3rdoc" maintainer="cyb3rdoc@proton.me"

# Install ffmpeg and other dependencies
RUN apk update \
  && apk add --no-cache \
	ffmpeg \
  && rm -rf /var/cache/apk/*

# Create app directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY ./src /

# Create volumes
VOLUME ["/config", "/storage"]

# Run the application
CMD python /app/main.py

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD python /app/healthcheck.py
