# Minimal Flask Example with Docker Compose and Nginx Reverse Proxy

This repository contains a **minimal Flask application** enhanced with **Docker Compose** and **Nginx** as a reverse proxy with logging. The setup allows local development and production-ready deployment using **uWSGI**.

---

## Features Implemented

1. **Flask Application**
   - Basic Flask app with a blueprint (`/api/v1/path_for_blueprint_x/test`) for testing endpoints.
   - Swagger API documentation integrated using:
     - `apispec`
     - `marshmallow`
     - `flask-swagger-ui`
     - `openapi-spec-validator`

2. **Dockerized Setup**
   - Flask app container using **uWSGI** for production deployment.
   - Application container **not exposed directly**; Nginx handles all incoming requests.

3. **Nginx Reverse Proxy**
   - Proxies all HTTP requests from port `80` to the Flask application container.
   - Logs all requests in standard Nginx format.
   - Configured in `nginx/default.conf`.

4. **Docker Compose**
   - Orchestrates Flask and Nginx containers together.
   - Ensures Flask is **internal only**, Nginx handles external access.
   - Run using `docker-compose up -d`.

---

## Getting Started

### Prerequisites
- Docker & Docker Compose installed.
- Python (for local testing if needed).

### Steps
1. Clone the repository and enter the folder:  
`git clone https://github.com/MohdFarhan311/minimal-flask-example.git && cd minimal-flask-example`

2. Build and start containers:  
`docker-compose up --build -d`

3. Check running containers:  
`docker ps`  
You should see:
- Flask app container (`minimal-flask`) running internally  
- Nginx container (`minimal-flask-nginx`) exposed on port 80

4. Access the Flask API via Nginx:  
`curl http://localhost/api/v1/path_for_blueprint_x/test`  
Expected response: JSON or API output from Flask application. All requests are logged by Nginx.

---

## Project Structure
minimal-flask-example/
├── Dockerfile # Flask application container
├── docker-compose.yml # Orchestrates Flask and Nginx containers
├── nginx/
│ └── default.conf # Nginx reverse proxy configuration with logging
├── src/
│ ├── app.py # Main Flask app
│ ├── api_spec.py # Swagger API spec
│ └── endpoints/ # Blueprint endpoints
├── test/
│ ├── conftest.py # Pytest configuration
│ └── test_endpoints.py # API endpoint tests
├── wsgi.py # uWSGI entrypoint for Flask
├── requirements.txt # Pinned Python dependencies
├── run_app_dev.sh # Run Flask in development mode
├── run_app_prod.sh # Run Flask in production mode
└── README.md # This file


---

## Docker Compose Services

| Service | Image/Container | Ports | Description |
|---------|----------------|-------|-------------|
| `flask` | minimal-flask-example_flask | internal only | Flask app with uWSGI |
| `nginx` | nginx:stable-alpine | 80:80 | Reverse proxy for Flask app with logging |

---

## Commands Summary

- Build & start: `docker-compose up --build -d`  
- Stop containers: `docker-compose down`  
- View logs: `docker logs <container_id>`  
- Test API: `curl http://localhost/api/v1/path_for_blueprint_x/test`

---

## Source of Proof

- **All changes pushed to GitHub**:
  - Branch: `main`
  - Commit: `"Add Docker Compose and Nginx reverse proxy with logging"`
  - Repository: [https://github.com/MohdFarhan311/minimal-flask-example](https://github.com/MohdFarhan311/minimal-flask-example)

---
<img width="1450" height="292" alt="Screenshot 2026-01-17 174143" src="https://github.com/user-attachments/assets/c35e3d0e-e39a-4608-8c5c-f9c426fa40a1" />

<img width="1886" height="447" alt="Screenshot 2026-01-17 180920" src="https://github.com/user-attachments/assets/cd9a1913-a784-4c9b-8824-3fc6c1629a8e" />

## Notes

- Flask container is **not exposed directly**, all external access goes through Nginx.  
- uWSGI handles Flask in **production mode**.  
- Swagger documentation is available via the app’s endpoints

