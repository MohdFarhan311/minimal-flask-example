# Kubernetes Deployment with Minikube (Flask + Nginx)

## Project Overview

This repository demonstrates deploying a containerized Flask application on a **Minikube-based Kubernetes cluster**, following real-world production practices.

The Flask application is **not exposed directly**. Instead, an **Nginx reverse proxy** is used to route and log all incoming requests. This setup ensures security, scalability, and proper separation of concerns, as required by the task.

---

## Objectives

- Provision a local Kubernetes cluster using **Minikube**
- Deploy a Flask application using Kubernetes
- Prevent direct exposure of the Flask container
- Use **Nginx as a reverse proxy**
- Ensure all external traffic passes through Nginx
- Log every incoming request via Nginx
- Validate the application via browser, API call, and automated tests

---

## High-Level Architecture
Client (Browser / API Request)
|
Nginx NodePort Service
|
Nginx Pod (Reverse Proxy + Logging)
|
Flask ClusterIP Service
|
Flask Pods (uWSGI running on port 8600)


---

## Components Description

### Minikube

Minikube is used to provision a **local, single-node Kubernetes cluster**. It allows running Kubernetes workloads locally and is ideal for development, testing, and demonstration purposes.

---

### Flask Application

- Built using Flask and served via **uWSGI**
- Runs internally on **port 8600**
- Deployed as multiple replicas for availability
- Not exposed to the outside world
- Accessible only within the Kubernetes cluster

The Flask application provides a test endpoint that returns a JSON response to confirm successful deployment.

---

### Nginx Reverse Proxy

- Acts as the **only public-facing component**
- Receives all incoming HTTP requests
- Proxies requests to the Flask backend service
- Logs every request
- Runs as a separate Kubernetes pod

This ensures that the backend application remains isolated and secure.

---

## Kubernetes Services Design

### Flask Service (ClusterIP)

- Service type: **ClusterIP**
- Scope: Internal only
- Purpose: Allows communication between Nginx and Flask pods
- Not accessible from outside the cluster

This design satisfies the requirement that the application container must not be exposed directly.

---

### Nginx Service (NodePort)

- Service type: **NodePort**
- Scope: External access
- Purpose: Entry point for all client traffic
- Routes traffic to the Nginx pod

All external access to the application happens through this service.

---
<img width="1249" height="131" alt="Screenshot 2026-01-18 060134" src="https://github.com/user-attachments/assets/3f179f6c-37c8-422c-8bcb-5fc1bd210c28" />

## Request Flow Explanation

1. A client sends a request via browser or API call
2. The request reaches the **Nginx NodePort Service**
3. Kubernetes forwards the request to the **Nginx Pod**
4. Nginx proxies the request to the **Flask ClusterIP Service**
5. The Flask service forwards the request to one of the Flask pods
6. The Flask application processes the request
7. The response is returned back through Nginx to the client

At no point is the Flask application directly exposed to the outside network.

---

## Application Endpoint

The deployed application exposes the following test endpoint:



/api/v1/path_for_blueprint_x/test

<img width="1602" height="136" alt="Screenshot 2026-01-18 060913" src="https://github.com/user-attachments/assets/00b05f44-7405-4ad2-93ae-0fb4d5341b96" />

### Expected Response

```json
{
  "msg": "I'm the test endpoint from blueprint_x."
}





A clean, production-style architecture

The solution fully satisfies the task requirements and mirrors real-world Kubernetes deployment patterns.
