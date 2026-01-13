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
