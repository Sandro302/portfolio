## Import OLGA Project (sequence)

```mermaid
sequenceDiagram
    actor Engineer
    participant CalcSys as "Calculation System\n(UI + API)"
    participant ImportSvc as "Import Service"
    participant DB as "Database\n(PostgreSQL)"
    participant Storage as "OLGA Files\n(Storage)"

    Engineer->>CalcSys: Select "Import OLGA Project"
    CalcSys-->>Engineer: Show file selection dialog
    Engineer->>CalcSys: Choose OLGA project files

    CalcSys->>ImportSvc: Upload files + metadata\n(name, description)
    ImportSvc->>ImportSvc: Parse & validate\nentities + structure
    ImportSvc->>Storage: Read OLGA files
    Storage-->>ImportSvc: Read complete

    ImportSvc->>DB: Save project & topology
    DB-->>ImportSvc: Save complete

    ImportSvc-->>CalcSys: Import result\n(success / warnings / errors)
    CalcSys-->>Engineer: Show status\n+ warnings/errors
