## Run Calculation Process (sequence)

```mermaid
sequenceDiagram
    actor Engineer
    participant UI as "UI / Client"
    participant API as "API Gateway"
    participant CalcSvc as "Calculation Service\n(Python wrapper)"
    participant Engine as "Calculation Engine\n(C++)"
    participant DB as "Database\n(PostgreSQL)"
    participant Notif as "Notification Service"

    Engineer->>UI: Configure parameters\nor select template
    Engineer->>UI: Click "Run calculation"

    UI->>API: POST /projects/{id}/calculations\n(parameters)
    API->>DB: Create CALCULATION row\nstatus = queued
    API->>CalcSvc: Enqueue calculation job\n(projectId, calculationId)

    CalcSvc->>Engine: Run calculation\n(input data snapshot)
    Engine->>Engine: Perform numerical\ncalculation

    Engine-->>CalcSvc: Results or error
    CalcSvc->>DB: Store results into\nCALCULATION_RESULTS
    CalcSvc->>DB: Update CALCULATIONS\nstatus = completed/failed\n+ error_message

    CalcSvc->>Notif: Send event\n(calculation.completed / failed)
    Notif-->>Engineer: Notify via UI/WebSocket

    Engineer->>UI: Open results screen
    UI->>API: GET /projects/{id}/results
    API->>DB: Read results
    API-->>UI: Return structured results
