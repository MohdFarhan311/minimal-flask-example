# Kubernetes Manifests – EKS Deployment

## Overview

This directory contains all Kubernetes manifests required to deploy the **Minimal Flask Application** on an **Amazon EKS (Elastic Kubernetes Service)** cluster using a production-style architecture.

The deployment follows industry best practices by separating concerns between:
- Application runtime (Flask)
- Reverse proxy (Nginx)
- Internal and external networking
- Configuration management

This setup mirrors how the application was validated locally using Minikube and then promoted to a production Kubernetes environment on AWS.

---

## Architecture

The application is deployed using the following flow:

Client  
→ AWS Load Balancer  
→ Nginx Service (LoadBalancer)  
→ Nginx Pod  
→ Flask Service (ClusterIP)  
→ Flask Pods (uwsgi, port 8600)

Nginx acts as a reverse proxy and is the **only component exposed publicly**.  
The Flask application remains internal to the cluster.

---

## Components in This Folder

### 1. Flask Application Deployment

The Flask application is deployed as a Kubernetes **Deployment** with:
- Multiple replicas for availability
- A container image pulled from **Amazon ECR**
- uwsgi running the application on port **8600**

The application is **not exposed directly to the internet**.

---

### 2. Flask Service (ClusterIP)

The Flask Service:
- Uses `ClusterIP` type
- Exposes port **8600**
- Allows internal communication within the cluster
- Is consumed only by the Nginx reverse proxy

This ensures proper service isolation and security.

---

### 3. Nginx Deployment

Nginx is deployed as a separate Kubernetes **Deployment** and acts as:
- Reverse proxy
- Single entry point to the application
- HTTP request router to the Flask service

The Nginx container uses a custom configuration that forwards traffic to the Flask service instead of serving the default Nginx page.

---
<img width="1427" height="139" alt="Screenshot 2026-01-18 114244" src="https://github.com/user-attachments/assets/5de37751-9d0a-4f49-b751-761f9623ed1e" />

### 4. Nginx ConfigMap

The Nginx configuration is provided using a **ConfigMap**, which:
- Defines upstream routing to the Flask service
- Avoids hardcoding configuration inside the container image
- Allows easy updates without rebuilding images

This ConfigMap replaces the default Nginx welcome page and ensures application traffic is correctly routed.

---

### 5. Nginx Service (LoadBalancer)

The Nginx Service:
- Uses `LoadBalancer` type
- Automatically provisions an **AWS Elastic Load Balancer**
- Exposes port **80** to the public internet

This is the **only externally accessible component** of the system.
<img width="1596" height="316" alt="Screenshot 2026-01-18 102142" src="https://github.com/user-attachments/assets/84efc3ed-4fad-4ce4-9786-0fe3e4d4d698" />

---

## Networking Model

- Flask Pods are accessible only via an internal ClusterIP service
- Nginx communicates with Flask using Kubernetes DNS
- External traffic never reaches Flask directly
- AWS handles external traffic routing via ELB

This design follows Kubernetes security and scalability best practices.

---

## Environment Parity

The same architectural pattern was used in:
- Local testing (Minikube)
- Production deployment (EKS)

This ensures:
- Predictable behavior across environments
- Easier debugging
- Reduced deployment risk

---

## Observability & Debugging (Conceptual)

The setup allows:
- Independent scaling of Flask and Nginx
- Isolated logging for application and proxy layers
- Easy inspection of pod and service health

All issues can be diagnosed by analyzing:
- Pod status
- Service routing
- Nginx configuration
- Application logs

---

## Why This Design Was Chosen

- Clear separation of concerns
- Production-grade Kubernetes layout
- Secure internal service exposure
- Cloud-native scalability
- Alignment with real-world DevOps practices

This structure is intentionally designed to resemble how Kubernetes workloads are deployed in professional production environments.

---

## Summary

This `eks/` folder fully defines the Kubernetes layer for the application, including:
- Application deployment
- Reverse proxy
- Internal and external services
- Configuration management

It completes the production deployment portion of the assignment and integrates seamlessly with Terraform-provisioned EKS infrastructure and CI/CD pipelines.
