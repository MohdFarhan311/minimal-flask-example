# CI/CD Pipeline for Flask Application on EKS

## Overview

This folder contains the CI/CD pipeline setup for deploying the Flask application to Amazon EKS using GitHub Actions. The pipeline automates the deployment process from code changes in the repository to updating the Kubernetes cluster in production. This ensures that every change, even minor ones, is applied consistently and reliably without manual intervention.

---

## Pipeline Design

The CI/CD pipeline is defined in the `github-ci.yml` file and includes the following key steps:

1. **Trigger**
   - The pipeline is triggered automatically on any push to the `main` branch.
   - Safe changes like annotations or minor manifest updates can also trigger the pipeline without affecting production functionality.
   - Example safe trigger annotation in Kubernetes manifests:
     ```yaml
     metadata:
       annotations:
         ci-trigger: "pipeline-test"
     ```

2. **Checkout Repository**
   - The workflow checks out the repository to the GitHub Actions runner.
   - All necessary Terraform and Kubernetes manifests are available for the deployment steps.

3. **Set up AWS Credentials**
   - The pipeline uses GitHub Secrets to authenticate with AWS.
   - Required secrets include:
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`
     - `AWS_REGION` (e.g., `us-east-1`)
   - These credentials allow the pipeline to interact with AWS resources such as ECR and EKS.

4. **Deploy Infrastructure (Terraform)**
   - Terraform is initialized and applied within the workflow.
   - The pipeline ensures that the required infrastructure is available, including:
     - ECR repository for container images
     - EKS cluster
     - IAM roles and policies for cluster access and deployment
   - Terraform uses a remote backend (S3) to store state, ensuring safe collaboration.

5. **Build and Push Docker Image**
   - The Flask application image is built from the `Dockerfile`.
   - The image is tagged and pushed to the AWS ECR repository.

6. **Deploy to EKS**
   - Kubernetes manifests from the `eks/` folder are applied using `kubectl`.
   - Deployments include:
     - Flask service
     - Nginx service (reverse proxy)
   - Pods are updated automatically if any manifest changes are detected.

7. **Post-deployment Verification**
   - Users can check the status of deployments and services in EKS using `kubectl`.
   - The pipeline ensures that the desired state matches the live cluster state.
<img width="1392" height="805" alt="Screenshot 2026-01-18 145415" src="https://github.com/user-attachments/assets/4b6e3da8-200f-4500-8068-0bbc5ff97ac4" />

---

## Development Environment

- Currently, the pipeline deploys only to the `default` namespace and `main` branch.
- Using a `dev` branch and a `dev` namespace would allow safe testing before production deployment.
- Safe trigger annotations (like `ci-trigger: "pipeline-test"`) can be added to manifests to test deployment without affecting functionality.

---

## Code Quality & Scans (Optional / Future)

- Static analysis, linting, and build checks can be added to the workflow to improve code quality.
- These are recommended for production CI pipelines but are considered out-of-scope for the current assignment.

---

## Future Improvements

- Introduce branch-based environments: `dev` branch → `dev` namespace, `main` branch → production namespace.
- Add automated code quality checks and vulnerability scanning using GitHub Actions or third-party tools.
- Include rollback strategies in case of failed deployments.
- Integrate monitoring and notifications for deployment success/failure.

---

## Summary

This CI/CD pipeline fully automates the process of taking code from GitHub, building the Docker image, pushing it to AWS ECR, and deploying the application to EKS. It ensures consistency, reliability, and minimal manual intervention while keeping the setup safe for experimentation and testing.
