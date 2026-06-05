# Mover Workflow

```mermaid
flowchart TD
    A[Employee Role Change] --> B[Validate HR Data]
    B --> C{Data Complete?}
    C -- No --> D[Stop Process<br>Validation Error]
    C -- Yes --> E[Check New Role Mapping]
    E --> F{Role Mapped?}
    F -- No --> G[Stop Process<br>No Role Mapping]
    F -- Yes --> H[Update User Role]
    H --> I[Update Security Groups]
    I --> J[Write Audit Log]
    J --> K[Generate HTML Report]