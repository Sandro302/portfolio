## Export Calculation Results to CSV (sequence)

```mermaid
sequenceDiagram
    actor Engineer
    participant UI as "UI / Client"
    participant API as "API Gateway"
    participant ExportSvc as "Export Service"
    participant DB as "Database\n(PostgreSQL)"
    participant FS as "File Storage\n(optional)"

    Engineer->>UI: Open project results
    Engineer->>UI: Click "Export to CSV"

    UI->>API: POST /projects/{id}/export\n(format = csv)
    API->>ExportSvc: Start export job\n(projectId, calculationId?)

    ExportSvc->>DB: Load latest successful\ncalculation results
    ExportSvc->>ExportSvc: Transform to tabular\nstructure (per node/segment)
    ExportSvc->>FS: Save CSV file (optional)

    ExportSvc-->>API: CSV stream or signed URL
    API-->>UI: Response with file\nor download link

    UI-->>Engineer: Download CSV file
