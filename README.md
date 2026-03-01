# Enterprise IAM Security Architecture (Azure)

## Core Guardrails Delivered 
This project focuses on Identity and Policy enforcement rather than paid platform workloads. It provisions:

- **Identity Foundation**: Entra ID Groups, Breakglass accounts, Custom RBAC definitions.
- **Privileged Identity Management**: JIT Access for critical roles based on temporary validity.
- **Zero-Trust Network**: Hub/Spoke topology without public IPs. Internal traffic regulated by strict NSGs.
- **Policy Enforcement**: Azure Policies enforcing HTTPS, Key Vault purge protection, Tag requirements, and denying public endpoint creation.
- **Managed Identities**: Workloads natively querying secrets via system-assigned identities.

## Architecture & Security Decisions Explained

As a Cloud Security Architect, the following design decisions were made to ensure this environment meets enterprise security standards using core Azure capabilities:

### 1. Secure Identity Foundation (Least Privilege & Zero Trust)
*   **No Direct Permissions:** Users are never assigned roles directly. Access is granted via Azure AD (Entra ID) Groups (`Developers`, `Security Engineers`, `SOC Analysts`, `Platform Engineers`, `Auditors`). This ensures scalable governance.
*   **Custom RBAC Roles:** Built-in roles often have too many permissions. We created custom roles (e.g., `Custom - Security Reader`, `Custom - SOC Analyst`) to enforce **Least Privilege Access**.

### 2. Privileged Access Management (JIT Elevation)
*   **Zero Standing Privileges:** Highly privileged administrative roles are NOT permanently assigned.
*   **Azure AD PIM Integration:** Eligible groups must request **Just-In-Time (JIT)** activation. Upon MFA and approval, permissions are granted for a maximum of 1 hour, significantly reducing the blast radius of compromised credentials.

### 3. Network Security Architecture (Defense in Depth)
*   **Hub-and-Spoke Topology:** Centralizes routing control securely. Spoke VNets containing application data are isolated.
*   **No Public IPs on Workloads:** VMs and databases do not have public IPs.
*   **Deny-By-Default NSGs:** Network Security Groups strictly deny all inbound internet traffic unless explicitly allowed.

### 4. Automated Policy Enforcement (Guardrails)
*   **Azure Policy:** Deployed at the subscription scope. Acts as a preventative guardrail.
    *   *Deny:* Public Storage Accounts, Unencrypted Storage, open network ports.
    *   *Require:* Specific tagging strategies for cost/security tracing.

### 5. Configured for Cost-Effective Demonstration
*   The architecture relies on free-tier capable SKUs (`Standard_B1s` instances), Free-tier Log Analytics Workspaces (30-day retention), and restricts expensive additions like App Gateways / Firewalls in favor of pure IAM/RBAC implementation.

## Deployment Instructions

1.  Review the architecture in `architecture.md`.
2.  Login to Azure CLI: `az login`
3.  Set your working directory to the target environment (e.g., `cd environments/dev`).
4.  Update the `terraform.tfvars` file with your specific `tenant_id` and `subscription_id`.
5.  Initialize Terraform: `terraform init`
6.  Plan the deployment: `terraform plan`
7.  Apply: `terraform apply`

*(Note: The IAM module provisions Azure AD Groups and Custom Roles at the subscription scope. The deploying user must have `Privileged Role Administrator` and `Owner` directory/subscription roles to deploy this successfully.)*
