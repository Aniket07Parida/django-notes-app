# 1. Use a 'slim' version to reduce image size and build time
FROM python:3.9-slim-bookworm

WORKDIR /app/backend

# 2. Optimized RUN command: 
# We removed 'apt-get upgrade' to save time and bandwidth.
# Added '--no-install-recommends' to keep the image light.
COPY requirements.txt /app/backend
RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# 3. Combine pip installs to reduce image layers
# 'mysqlclient' is usually in your requirements.txt, but keeping it here is fine.
RUN pip install --no-cache-dir mysqlclient -r requirements.txt

# 4. Copy the rest of the code
COPY . /app/backend

EXPOSE 8000

# Optional: Add a non-root user here for better security later.
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
