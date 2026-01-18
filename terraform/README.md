# Terraform Infrastructure – AWS EKS & ECR

## Overview

This directory contains the **Terraform configuration** used to provision the complete AWS infrastructure required to run the Minimal Flask Application in **production**.

The infrastructure is fully automated and includes:
- An Amazon EKS (Elastic Kubernetes Service) cluster
- An Amazon ECR (Elastic Container Registry) repository
- Required IAM roles and policies
- AWS networking using the default VPC
- Outputs to integrate infrastructure with Kubernetes and CI/CD pipelines

This setup represents a **production-grade Infrastructure as Code (IaC)**
implementation.
 <img width="1345" height="196" alt="Screenshot 2026-01-18 090033" src="https://github.com/user-attachments/assets/4a552fed-2986-4add-91a1-80330c71d67b" />

---



## Infrastructure Goals

The Terraform configuration is designed to:

- Automate infrastructure provisioning
- Ensure reproducibility across environments
- Follow AWS security and IAM best practices
- Support CI/CD-driven application deployments
- Separate infrastructure concerns from application logic

---
## To make it better:
Var.tf and modules 
## High-Level Architecture

Docker Image  
→ Amazon ECR  
→ Amazon EKS  
→ Kubernetes Deployments & Services  

Terraform is responsible **only for infrastructure**, not application manifests.

---

## Files and Responsibilities

### provider.tf

Defines:
- AWS as the cloud provider
- The AWS region
- Provider configuration used across all Terraform resources

This file acts as the **entry point** for Terraform to communicate with AWS APIs.

---

### backend.tf

Configures Terraform state management.

Responsibilities:
- Stores Terraform state remotely
- Enables collaboration and consistency
- Prevents state corruption
- Allows safe re-runs and updates

Using a remote backend ensures Terraform behaves predictably in team or CI environments.

---

### eks.tf

Defines the **Amazon EKS cluster** and node group.

Includes:
- EKS control plane configuration
- Node group for running Kubernetes workloads
- Integration with the default VPC and subnets
- Scaling configuration for worker nodes

This file provisions the **Kubernetes control plane and compute layer**.
<img width="1858" height="834" alt="Screenshot 2026-01-18 092916" src="https://github.com/user-attachments/assets/ea6c2746-1f6c-4c06-91e7-6c11bf2f5043" />

---

### ecr.tf

Creates an **Amazon ECR repository** used to store Docker images.

Responsibilities:
- Acts as the source of truth for container images
- Integrates with CI pipelines for image pushes
- Supplies images to EKS deployments

ECR enables secure, private container image storage within AWS.
<img width="1871" height="687" alt="Screenshot 2026-01-18 092942" src="https://github.com/user-attachments/assets/5dc4ca76-03f5-4439-9e82-9eceabd60c06" />
<img width="1884" height="447" alt="Screenshot 2026-01-18 095039" src="https://github.com/user-attachments/assets/77b493ff-f6fd-4e69-b79f-5e906f0d9f71" />

---

### iam.tf

Defines **IAM roles and policies** required for the infrastructure to function.

Includes roles for:
- EKS control plane
- EKS worker nodes
- Access to ECR
- Communication with AWS services

This file enforces **least-privilege access** and ensures AWS resources can assume the correct permissions.

---

### outputs.tf

Exposes useful infrastructure information such as:
- EKS cluster name
- Cluster endpoint
- ECR repository URL

Outputs allow:
- Kubernetes tooling to connect to EKS
- CI/CD pipelines to reference ECR
- Clear separation between provisioning and usage layers

---

## IAM Policy Design (Conceptual)

The IAM roles created by Terraform allow AWS resources to:

- Create and manage EKS clusters
- Launch and manage EC2 worker nodes
- Pull container images from ECR
- Communicate securely with AWS APIs

Each role is scoped specifically to its responsibility to maintain security and compliance.

---

## Environment Strategy

This Terraform setup supports:
- Development environments
- Production environments
- CI/CD automation

Environment-specific behavior can be introduced later using:
- Variables
- Separate state backends
- Workspaces

---

## Relationship With CI/CD

Terraform provisions:
- Infrastructure
- Registries
- Permissions

CI/CD pipelines:
- Build Docker images
- Push images to ECR
- Deploy Kubernetes manifests to EKS

This clean separation ensures:
- Infrastructure stability
- Faster application deployments
- Easier troubleshooting

---

## Why This Structure Was Chosen

- Simple and readable file separation
- No unnecessary modules for clarity
- Easy to understand for reviewers and interviewers
- Reflects real-world DevOps infrastructure design

The goal is correctness, clarity, and production realism.

---

## Summary

This Terraform configuration fully automates the AWS infrastructure needed to run the application in production.

It:
- Creates EKS and ECR
- Manages IAM securely
- Supports CI/CD workflows
- Complements Kubernetes manifests cleanly

Together with the Kubernetes and CI pipelines, this completes the production deployment architecture.
