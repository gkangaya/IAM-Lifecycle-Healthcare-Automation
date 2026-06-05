# Leaver Workflow

```mermaid
flowchart TD
    A[Employee Departure] --> B[Validate Employee Record]
    B --> C[Disable User Account]
    C --> D[Remove Security Groups]
    D --> E[Write Audit Log]
    E --> F[Generate HTML Report]