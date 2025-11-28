FROM python:3.10-slim

# --- System deps required by Playwright browsers ---
RUN apt-get update && apt-get install -y \
    wget gnupg ca-certificates curl unzip \
    libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxkbcommon0 \
    libgtk-3-0 libgbm1 libasound2 libxcomposite1 libxdamage1 libxrandr2 \
    libxfixes3 libpango-1.0-0 libcairo2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# --- Install dependencies ---
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# --- Install Playwright + Chromium ---
RUN playwright install chromium

# --- Copy app to container ---
COPY . .

ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=utf-8

# HuggingFace Spaces exposes port 7860
EXPOSE 7860

# --- Run your FastAPI app ---
CMD ["python", "main.py"]
