# Local MVP Architecture

```mermaid
flowchart TD
    A[HR CSV File<br>employees.csv] --> B[IAM Lifecycle Engine<br>PowerShell]
    B --> C[RBAC Mapping<br>RoleMappings.csv]
    B --> D[Simulated User Store<br>simulated_users.csv]
    B --> E[Audit Log<br>audit_log.csv]
    B --> F[HTML Report<br>Healthcare IAM Report]

    C --> B