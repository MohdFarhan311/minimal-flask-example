# Monitoring & Observability on EKS using kube-prometheus-stack

## Overview

This setup implements cluster-wide monitoring and observability for an Amazon EKS cluster using the kube-prometheus-stack. It helps identify resource consumption across the Kubernetes cluster and worker nodes (EC2 machines), as well as application-level metrics for workloads running in the cluster.

The stack includes:
- Prometheus
- Grafana
- Alertmanager
- kube-state-metrics
- node-exporter

---

## Prerequisites

- Running Amazon EKS cluster
- kubectl configured to access EKS
- Helm installed on local machine
- Cluster nodes with outbound internet access

Verify access:
kubectl get nodes

Verify helm:
helm version

---

## Step 1: Add Prometheus Helm Repository

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts  
helm repo update

---

## Step 2: Create Monitoring Namespace

kubectl create namespace monitoring  
kubectl get ns

---

## Step 3: Install kube-prometheus-stack

helm install monitoring prometheus-community/kube-prometheus-stack \
-n monitoring

This installs Prometheus, Grafana, Alertmanager, node-exporter, and kube-state-metrics in the monitoring namespace.
<img width="1751" height="860" alt="Screenshot 2026-01-18 152658" src="https://github.com/user-attachments/assets/fcef1635-a2a3-47da-b066-f4badf9db6d4" />
<img width="1890" height="405" alt="Screenshot 2026-01-18 173728" src="https://github.com/user-attachments/assets/8cad9b44-a645-4f3e-8df7-61260c0e4f1c" />

---

## Step 4: Verify Installation

kubectl get all -n monitoring

Expected:
- Prometheus pods running
- Grafana pod running
- node-exporter running on all nodes
- kube-state-metrics running

---

## Step 5: Access Monitoring UIs

### Prometheus

kubectl port-forward service/prometheus-operated \
-n monitoring 9090:9090

Access:
http://localhost:9090
<img width="1874" height="949" alt="Screenshot 2026-01-18 153013" src="https://github.com/user-attachments/assets/ecfbbba0-c45a-42e8-bde2-4cfe9bd4ce6c" />
<img width="1888" height="893" alt="Screenshot 2026-01-18 153108" src="https://github.com/user-attachments/assets/a582e62e-0a9b-43b9-8ad5-003496a4a493" />

---

### Grafana

kubectl port-forward service/monitoring-grafana \
-n monitoring 8080:80

Access:
http://localhost:8080

Default login:
Username: admin  
Password: admin

---
<img width="1910" height="1014" alt="Screenshot 2026-01-18 155801" src="https://github.com/user-attachments/assets/ab7975ba-c5ed-4a9c-8f2f-f100899c607c" />
<img width="1682" height="188" alt="Screenshot 2026-01-18 162052" src="https://github.com/user-attachments/assets/1e341a78-aa64-44d9-81d6-8688f2656e14" />
<img width="1876" height="246" alt="Screenshot 2026-01-18 173832" src="https://github.com/user-attachments/assets/5960eb0e-ab85-4a37-a181-00757e363492" />
<img width="1890" height="150" alt="Screenshot 2026-01-18 173728" src="https://github.com/user-attachments/assets/a01481cf-c58a-4712-8c92-e2e00c210ab7" />

### Alertmanager

kubectl port-forward service/alertmanager-operated \
-n monitoring 9093:9093

Access:
http://localhost:9093

---

## Step 6: Grafana Dashboards Used

The following prebuilt dashboards were used to monitor resource usage:

Cluster-wide usage:
Kubernetes / Compute Resources / Cluster

Namespace-level usage:
Kubernetes / Compute Resources / Namespace (Pods)
Selected namespace: default

Pod-level metrics:
Kubernetes / Compute Resources / Pod
Used to monitor Flask and Nginx pods

Node-level (machine) metrics:
Kubernetes / Compute Resources / Node (Pods)
Shows CPU and memory usage of EKS worker nodes (EC2 instances)

---
<img width="1485" height="731" alt="Screenshot 2026-01-18 155549" src="https://github.com/user-attachments/assets/9c9e1a10-a752-440d-b703-6380777fe1ef" />
<img width="1876" height="246" alt="Screenshot 2026-01-18 173832" src="https://github.com/user-attachments/assets/18643b24-a777-45f9-b2c6-169dcff56707" />


## Metrics Coverage

This setup provides visibility into:
- Total cluster CPU and memory usage
- Namespace-wise pod resource usage
- Pod and container-level metrics
- Node (EC2) resource consumption
- Application workloads running in default namespace
<img width="1819" height="964" alt="Screenshot 2026-01-18 173458" src="https://github.com/user-attachments/assets/37a90a26-1871-4a6b-9272-3b6677b7410c" />

---

## Cleanup (Optional)

helm uninstall monitoring -n monitoring  
kubectl delete namespace monitoring

---

## Summary

The kube-prometheus-stack was successfully deployed on the EKS cluster to monitor Kubernetes resources and node-level consumption using Prometheus and Grafana. This fulfills the requirement of identifying resource usage across the Kubernetes cluster and underlying machines using a production-grade observability stack.
