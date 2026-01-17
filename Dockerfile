# Dockerfile
FROM python:3.9-slim

WORKDIR /app

# Install gcc for any compilation
RUN apt-get update && apt-get install -y gcc && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy repo
COPY . .

# Expose internal port (do NOT expose externally)
EXPOSE 8600

# Start Flask in production as task suggests
CMD ["uwsgi", "--ini", "app.ini"]


