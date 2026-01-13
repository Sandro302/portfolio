## Import OLGA Project (sequence)

```plantuml
@startuml
skinparam {
    backgroundColor #FFFFFF
    ParticipantBorderColor #333333
    ParticipantBackgroundColor #E8F4F8
    ArrowColor #333333
    fontSize 12
}

title Import OLGA Project Process

actor Engineer
participant "Calculation System\n(UI + API)" as CalcSys
participant "Import Service" as ImportSvc
database "Database\n(PostgreSQL)" as DB
participant "OLGA Files\n(Storage)" as Storage

Engineer -> CalcSys : Select "Import OLGA Project"
Engineer -> CalcSys : Show file selection dialog
Engineer -> CalcSys : Choose OLGA project files
activate CalcSys

CalcSys -> ImportSvc : Upload files + metadata\n(name, description)
activate ImportSvc

ImportSvc -> ImportSvc : Parse entities\n(nodes, pipes, profiles)
ImportSvc -> ImportSvc : Validate structure/version
ImportSvc -> ImportSvc : Write import log\n(status, message, timestamp)

ImportSvc -> Storage : Read OLGA files\n(validate structure/version)
activate Storage
Storage --> ImportSvc : Read complete
deactivate Storage

ImportSvc -> DB : Save project and\ntopology data
activate DB
DB --> ImportSvc : Save complete
deactivate DB

ImportSvc -> Storage : Save parsed data
ImportSvc --> CalcSys : Import result\n(success / warnings / errors)
deactivate ImportSvc

CalcSys --> Engineer : Show import status\nlist of warnings/errors
deactivate CalcSys

@enduml
