# Enterprise Zero-Trust Azure Architecture

## 📌 Project Overview
The **Enterprise Zero-Trust Azure Architecture** is an Infrastructure-as-Code (IaC) deployment utilizing Terraform to provision a highly secure, hub-and-spoke enterprise environment. This project demonstrates strict adherence to NIST SP 800-53 Rev 5 compliance, Identity and Access Management (IAM), and continuous security auditing mechanisms.

## 🛠 Phase 1: Foundational Infrastructure (Terraform)
*   **Objective:** Automate the provisioning of isolated virtual networks and critical infrastructure layers.
*   **Key Deliverables:**
    *   Deployed a robust **Hub-and-Spoke** topology across 3 distinct virtual networks using HashiCorp Terraform.
    *   Provisioned centralized jump boxes and segmented application subnets.

## 🔒 Phase 2: Security Hardening & Zero-Trust
*   **Objective:** Enforce zero-trust principles across compute, storage, and identity perimeters.
*   **Key Deliverables:**
    *   Hardened **Network Security Groups (NSGs)** to explicitly block unauthorized internet ingress (RDP/SSH).
    *   Disabled public network access entirely for blob storage containers.
    *   Enforced mandatory **TLS 1.2 minimums** and disabled legacy protocols (FTPS) for secure data-in-transit.

## ⚡ Phase 3: Compliance & Automated Policy Enforcement
*   **Objective:** Establish non-repudiation and continuous regulatory compliance checks.
*   **Key Deliverables:**
    *   Enabled **Diagnostic Logging** for Azure Key Vaults and Storage Accounts to send logs directly to a central Log Analytics Workspace.
    *   Enforced **Purge Protection** and Soft Delete policies to prevent accidental or malicious destruction of encryption keys.
    *   Achieved measurable compliance improvements against regulatory frameworks via the Azure Security Center.

## 🚀 How to Deploy / Step-by-Step Instructions
1. **Prerequisites:** Ensure you have the Azure CLI (`az login`) and Terraform installed.
2. **Initialize Terraform:** Navigate to the project directory and run `terraform init` to download provider plugins.
3. **Plan Infrastructure:** Run `terraform plan -out=tfplan` to review the hub-and-spoke virtual networks and NSG rules before deployment.
4. **Deploy:** Execute `terraform apply tfplan`.
5. **Verify:** Navigate to your Azure Portal to confirm the 3 isolated VNETs and ensure Blob Storage public access is disabled.
6. **Destroy:** Run `terraform destroy` when finished to prevent incurring cloud costs.

## 📸 Technical Evidence
*(Azure Portal compliance dashboards and Terraform apply logs to be added here)*
