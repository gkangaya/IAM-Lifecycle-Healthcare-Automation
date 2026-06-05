# IAM Lifecycle Healthcare Automation

## Overview

This project demonstrates an Identity and Access Management (IAM) lifecycle automation solution designed for healthcare organizations.

The solution automates employee onboarding, role changes, and offboarding while enforcing governance controls, role-based access control (RBAC), auditing, and reporting.

## Business Problem

Healthcare organizations often face challenges such as:

* Manual account creation
* Delayed access provisioning
* Excessive user permissions
* Orphaned accounts
* Audit and compliance risks

This project demonstrates how IAM automation can reduce these risks.

---

## Solution Components

### Employee Lifecycle Management

* Joiner (New Employee)
* Mover (Role Change)
* Leaver (Employee Departure)

### Governance Controls

* Mandatory Manager Validation
* Department Validation
* Job Title Validation
* Start Date Validation
* RBAC Validation

### Access Management

Role-based access assignment using external role mappings.

### Audit & Reporting

* Audit Log Generation
* HTML Reporting
* Validation Error Reporting

---

## Architecture

HR Source (employees.csv)
↓
IAM Lifecycle Engine (PowerShell)
↓
RBAC Mapping (RoleMappings.csv)
↓
User Provisioning
↓
Audit Logging
↓
HTML Reporting

---

## Features

### Joiner

Creates user accounts and assigns access based on role.

### Mover

Updates access when employee roles change.

### Leaver

Disables accounts and removes access.

### Governance

Prevents provisioning when mandatory information is missing.

### RBAC

Assigns security groups based on job role.

---

## Example Validation Errors

* Missing Manager
* Missing Department
* Missing Last Name
* Missing Role Mapping

---

## Generated Outputs

* simulated_users.csv
* audit_log.csv
* Healthcare-IAM-Lifecycle-Report.html

---

## Technologies

* PowerShell
* Git
* GitHub
* CSV
* HTML

---

## Future Roadmap

Phase 1 – Local MVP (Completed)

* IAM Lifecycle Automation
* Governance Controls
* RBAC
* Audit
* Reporting

Phase 2 – Enterprise Lab

* Windows Server 2022
* Active Directory
* DNS
* Organizational Units
* Security Groups

Phase 3 – Cloud IAM

* Microsoft Entra ID
* Microsoft 365
* Automated Provisioning

Phase 4 – Enterprise Integration

* ITSM Integration
* HR Integration
* Approval Workflows
* Access Reviews

---

## Author

Gervais Francis Kangaya

* BSc Information Technology
* ISC2 Certified in Cybersecurity (CC)
* IAM Analyst
* Microsoft Entra ID
* Broadcom Identity Manager (IDM)
* Broadcom Identity Governance (IDG)
* 10+ Years of IT Experience
