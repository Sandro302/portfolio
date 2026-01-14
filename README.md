
# Fullstack Analyst Portfolio

Профессиональное портфолио системного / fullstack аналитика на основе реального инженерного проекта расчёта и визуализации параметров трубопроводной системы.

---

## О себе

Я **Fullstack аналитик** с опытом работы в области:
- системного анализа и описания требований
- моделирования бизнес‑процессов (BPMN)
- проектирования архитектуры и API
- проектирования и реализации баз данных (PostgreSQL, SQL)
- технической документации и сопровождения разработки

Основная область: инженерные и расчётные системы, интеграция GUI/сервисов/БД и расчётных модулей (C++/Python).

---

## Цель этого портфолио

Это репозиторий, который демонстрирует полный цикл работы аналитика на одном сквозном кейсе:

> От бизнес‑требований и BPMN → через Use Cases и UML → к ER‑модели и SQL → до REST API и архитектуры системы.

Портфолио ориентировано на собеседования на позиции:
- System Analyst / Business Systems Analyst
- Fullstack Analyst / Product Analyst с уклоном в backend/данные
- Аналитик в инженерных/интеграционных/платформенных командах

---

## Структура репозитория

```text
fullstack-analyst-portfolio/
├── README.md                 # этот файл
└── projects/
    └── 01_Engineering_System/
        ├── README.md         # кейс-стади проекта
        ├── 01_Requirements/  # требования
        ├── 02_Use_Cases/     # use cases + диаграммы
        ├── 03_BPMN_Processes/
        ├── 04_UML_Diagrams/
        ├── 05_Data_Model/    # ER + SQL + Data Dictionary
        ├── 06_API_Specification/
        ├── 07_System_Architecture/
        ├── 08_UI_Mockups/
        ├── 09_Technical_Specification/
        └── 10_Summary/

## 📚 API документация

Полная документация Engineering Pipeline Calculation System API находится в папке [`docs/`](./docs/):

- **[🔧 Swagger UI + ReDoc (Комбо)](./docs/full.html)** — Интерактивное тестирование и документация
- **[📖 ReDoc](./docs/index.html)** — Красивый просмотр документации
- **[🔧 Swagger UI](./docs/swagger.html)** — Тестирование эндпоинтов API
