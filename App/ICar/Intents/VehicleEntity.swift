import AppIntents

struct VehicleEntity: AppEntity, IndexedEntity {
    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Vehicle")
    static let defaultQuery = VehicleEntityQuery()

    let id: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "My iCar")
    }

    init(id: String = "my-icar") {
        self.id = id
    }
}

struct VehicleEntityQuery: EntityQuery {
    func entities(for identifiers: [VehicleEntity.ID]) async throws -> [VehicleEntity] {
        identifiers.compactMap { $0 == "my-icar" ? VehicleEntity(id: $0) : nil }
    }

    func suggestedEntities() async throws -> [VehicleEntity] {
        [VehicleEntity()]
    }
}
