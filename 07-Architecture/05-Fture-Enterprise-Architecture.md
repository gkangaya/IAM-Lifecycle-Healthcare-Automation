# Future Enterprise Architecture

```mermaid
flowchart TD
    A[HR System<br>Workday / SAP / Oracle HCM] --> B[ITSM<br>ServiceNow / Jira]
    B --> C[IAM Workflow Engine]
    C --> D[Active Directory]
    C --> E[Microsoft Entra ID]
    E --> F[Microsoft 365]
    C --> G[Clinical Applications]
    C --> H[Audit & Reporting]
    D --> H
    E --> H
    F --> H
    G --> H