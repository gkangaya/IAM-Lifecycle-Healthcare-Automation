# Healthcare IAM Lifecycle Automation

## Executive Summary

### Project Overview

The Healthcare IAM Lifecycle Automation project demonstrates how Identity and Access Management (IAM) processes can be automated to improve security, compliance, operational efficiency, and governance within healthcare organizations.

The solution automates the employee lifecycle management process by handling employee onboarding, role changes, and departures while enforcing Role-Based Access Control (RBAC), governance validations, auditing, and reporting.

---

## Business Challenge

Healthcare organizations frequently face challenges related to:

* Manual account creation and provisioning
* Delayed access assignment
* Excessive user permissions
* Inconsistent access controls
* Orphaned accounts after employee departures
* Compliance and audit requirements
* Human errors in access management processes

These challenges increase operational costs and security risks.

---

## Proposed Solution

The proposed solution introduces an automated IAM workflow engine capable of processing employee lifecycle events.

The solution supports:

### Joiner Process

* New employee onboarding
* User account creation
* Automatic group assignment
* RBAC enforcement
* Audit logging

### Mover Process

* Role change management
* Automatic access updates
* Group membership modification
* Audit logging

### Leaver Process

* Account disabling
* Access removal
* Audit logging
* Compliance reporting

---

## Governance Controls

The solution validates employee records before any provisioning activity occurs.

Mandatory controls include:

* Manager validation
* Department validation
* Job title validation
* RBAC mapping validation

Provisioning is blocked when required information is missing.

---

## Role-Based Access Control (RBAC)

Access is assigned based on employee job roles.

Examples:

| Role           | Assigned Groups                |
| -------------- | ------------------------------ |
| Nurse          | GRP_NURSES, GRP_PATIENT_PORTAL |
| IAM Analyst    | GRP_IT_IAM, GRP_ADMIN_TOOLS    |
| Lab Technician | GRP_LAB, GRP_LAB_SYSTEM        |

This approach supports the principle of least privilege.

---

## Reporting and Auditing

The solution generates:

* User provisioning records
* Audit logs
* Governance validation results
* HTML lifecycle reports

This improves audit readiness and traceability.

---

## Current MVP Scope

Completed components:

* Employee lifecycle engine
* RBAC mapping
* Governance validation
* Audit logging
* HTML reporting
* Architecture diagrams
* GitHub repository

---

## Future Roadmap

### Phase 2

Windows Server 2022

Active Directory Integration

Security Group Automation

PowerShell Active Directory Module

### Phase 3

Microsoft Entra ID Integration

Microsoft 365 Provisioning

Hybrid Identity Management

### Phase 4

ITSM Integration

HR System Integration

Approval Workflows

Access Reviews

---

## Business Benefits

* Reduced manual effort
* Faster onboarding
* Improved security
* Better governance
* Compliance support
* Increased operational efficiency

---

## Author

Gervais Francis Kangaya

BSc Information Technology

ISC2 Certified in Cybersecurity (CC)

IAM Analyst

Microsoft Entra ID

Broadcom Identity Manager (IDM)

Broadcom Identity Governance (IDG)

10+ Years of IT Experience
