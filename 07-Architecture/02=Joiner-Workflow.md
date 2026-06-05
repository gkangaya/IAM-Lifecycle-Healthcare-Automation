# Joiner Workflow

```mermaid
flowchart TD
    A[New Employee from HR] --> B[Validate HR Data]
    B --> C{Data Complete?}
    C -- No --> D[Stop Process<br>Validation Error]
    C -- Yes --> E[Check RBAC Mapping]
    E --> F{Role Mapped?}
    F -- No --> G[Stop Process<br>No Role Mapping]
    F -- Yes --> H[Create User Account]
    H --> I[Assign Security Groups]
    I --> J[Write Audit Log]
    J --> K[Generate HTML Report]
    