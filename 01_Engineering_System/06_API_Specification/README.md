text
# 📡 Engineering Pipeline Calculation System API

REST API для системы расчёта и визуализации параметров трубопровода.

## 🚀 Quick Links

- **[📖 Full API Documentation](./docs/)** — Interactive ReDoc
- **[📦 OpenAPI Spec](./openapi.yaml)** — Raw specification
- **[💾 Examples](./examples/)** — Code examples
- **[📋 Changelog](./CHANGELOG.md)** — Version history

---

## 📚 API Overview

### Base URLs
- **Production**: `https://api.example.com/v1`
- **Sandbox**: `https://sandbox.api.example.com/v1`

### Main Endpoints

#### Projects Management
```bash
GET    /projects                    # List all projects
POST   /projects                    # Create new project
GET    /projects/{projectId}        # Get project details
DELETE /projects/{projectId}        # Delete project
OLGA Import
bash
POST   /projects/import/olga        # Import OLGA files
Calculations
bash
POST   /projects/{projectId}/calculations           # Start calculation
GET    /projects/{projectId}/calculations           # List calculations
GET    /projects/{projectId}/calculations/{calcId}  # Get calculation details
Results & Export
bash
GET    /projects/{projectId}/results                # Get results
POST   /projects/{projectId}/export                 # Export to CSV
Notifications
bash
POST   /projects/{projectId}/subscribe              # Subscribe to updates
🔧 Quick Examples
Create a Project
bash
curl -X POST https://api.example.com/v1/projects \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Pipeline Alpha",
    "description": "Main pipeline analysis"
  }'
Response (201):

json
{
  "id": "proj_123abc",
  "name": "Pipeline Alpha",
  "status": "ready",
  "createdAt": "2026-01-14T12:00:00Z"
}
Import OLGA Files
bash
curl -X POST https://api.example.com/v1/projects/import/olga \
  -F "name=Pipeline Alpha" \
  -F "description=Main pipeline" \
  -F "files=@project.opi" \
  -F "files=@project.tpl"
Response (201):

json
{
  "project": {
    "id": "proj_456def",
    "name": "Pipeline Alpha",
    "status": "ready"
  },
  "warnings": []
}
Start Calculation
bash
curl -X POST https://api.example.com/v1/projects/proj_123/calculations \
  -H "Content-Type: application/json" \
  -d '{
    "parametersOverride": {
      "iterations": 100,
      "tolerance": 0.001
    }
  }'
Response (202 Accepted):

json
{
  "calculationId": "calc_789ghi",
  "status": "queued"
}
Get Calculation Results
bash
curl -X GET https://api.example.com/v1/projects/proj_123/results
Response (200):

json
{
  "projectId": "proj_123abc",
  "calculationId": "calc_789ghi",
  "nodes": [
    {
      "nodeId": "node_001",
      "pressure": 2.5,
      "temperature": 25.0,
      "flowRate": 100.5
    }
  ],
  "segments": [
    {
      "segmentId": "seg_001",
      "inletPressure": 3.0,
      "outletPressure": 2.5,
      "inletTemperature": 30.0,
      "outletTemperature": 28.5
    }
  ]
}
Export Results to CSV
bash
curl -X POST https://api.example.com/v1/projects/proj_123/export \
  -H "Content-Type: application/json" \
  -d '{
    "format": "csv",
    "includeHeaders": true
  }' \
  -o results.csv
Subscribe to Updates
bash
curl -X POST https://api.example.com/v1/projects/proj_123/subscribe \
  -H "Content-Type: application/json" \
  -d '{
    "channelType": "webhook",
    "target": "https://your-app.com/webhooks/calculations",
    "events": [
      "calculation.started",
      "calculation.completed",
      "calculation.failed"
    ]
  }'
📊 API Tags
Tag	Description
Projects	Project management and metadata
Import	OLGA file import functionality
Calculations	Calculation execution and monitoring
Results	Results retrieval and export
Notifications	WebSocket and webhook subscriptions
🔐 Security
Authentication: Bearer Token (JWT)

HTTPS required for all endpoints

Rate limiting: 1000 requests/hour

📦 File Formats Supported
Format	Type	Extension
OLGA	Input	.opi, .tpl, .tab
CSV	Export	.csv
JSON	Export	.json
🔄 Async Operations
The API supports asynchronous operations using:

202 Accepted - Request queued for processing

Webhooks - Real-time notifications on completion

Status polling - Check calculation status

📝 Response Codes
Code	Meaning
200	OK - Request successful
201	Created - Resource created
202	Accepted - Async request queued
204	No Content - Successful deletion
400	Bad Request - Invalid parameters
404	Not Found - Resource doesn't exist
409	Conflict - State conflict
500	Server Error - Internal server error
📚 Full Documentation
For complete API documentation with interactive examples, visit the Interactive API Docs

📞 Support
Email: support@example.com

Issues: GitHub Issues

Documentation: Full Docs

📄 License
MIT License - See LICENSE file

text

### **`06_API_Specification/examples/curl-examples.sh`**

```bash
#!/bin/bash

# Engineering Pipeline API - cURL Examples

API_BASE_URL="https://api.example.com/v1"
PROJECT_ID="proj_123abc"

echo "🚀 Engineering Pipeline API Examples"
echo "===================================="
echo ""

# 1. List Projects
echo "1️⃣  GET - List All Projects"
echo "Command:"
echo "curl -X GET $API_BASE_URL/projects?limit=10"
echo ""

# 2. Create Project
echo "2️⃣  POST - Create New Project"
echo "Command:"
echo "curl -X POST $API_BASE_URL/projects \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"name\": \"Pipeline Alpha\", \"description\": \"Main pipeline\"}'"
echo ""

# 3. Import OLGA
echo "3️⃣  POST - Import OLGA Files"
echo "Command:"
echo "curl -X POST $API_BASE_URL/projects/import/olga \\"
echo "  -F 'name=Pipeline Alpha' \\"
echo "  -F 'files=@project.opi'"
echo ""

# 4. Start Calculation
echo "4️⃣  POST - Start Calculation"
echo "Command:"
echo "curl -X POST $API_BASE_URL/projects/$PROJECT_ID/calculations \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"parametersOverride\": {\"iterations\": 100}}'"
echo ""

# 5. Get Results
echo "5️⃣  GET - Get Calculation Results"
echo "Command:"
echo "curl -X GET $API_BASE_URL/projects/$PROJECT_ID/results"
echo ""

# 6. Export Results
echo "6️⃣  POST - Export Results to CSV"
echo "Command:"
echo "curl -X POST $API_BASE_URL/projects/$PROJECT_ID/export \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"format\": \"csv\"}' \\"
echo "  -o results.csv"
echo ""

# 7. Subscribe to Events
echo "7️⃣  POST - Subscribe to Webhook Events"
echo "Command:"
echo "curl -X POST $API_BASE_URL/projects/$PROJECT_ID/subscribe \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"channelType\": \"webhook\", \"target\": \"https://your-app.com/webhooks\", \"events\": [\"calculation.completed\"]}'"
echo ""
06_API_Specification/CHANGELOG.md
text
# Changelog

All notable changes to the Engineering Pipeline API will be documented in this file.

## [1.0.0] - 2026-01-14

### Added
- Initial API release
- Projects management (CRUD operations)
- OLGA file import support
- Calculation engine with async processing
- Results retrieval and export to CSV
- WebSocket and Webhook notifications
- Comprehensive OpenAPI 3.0.3 specification

### Features
- ✅ Project management
- ✅ OLGA file import (.opi, .tpl, .tab)
- ✅ Asynchronous calculations (202 Accepted pattern)
- ✅ Real-time notifications via webhooks
- ✅ CSV export functionality
- ✅ Detailed API documentation with ReDoc

### Endpoints
- `GET /projects` - List projects
- `POST /projects` - Create project
- `POST /projects/import/olga` - Import OLGA files
- `POST /projects/{id}/calculations` - Start calculation
- `GET /projects/{id}/results` - Get results
- `POST /projects/{id}/export` - Export to CSV
- `POST /projects/{id}/subscribe` - WebSocket subscription

---

## Planned Features (Future Versions)

- [ ] Real-time WebSocket calculations
- [ ] Advanced filtering and search
- [ ] Batch operations
- [ ] API usage analytics
- [ ] Rate limiting tiers
- [ ] OAuth 2.0 authentication
