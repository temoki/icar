import AppIntents

struct CarEntity: AppEntity, IndexedEntity {
    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Car")
    static let defaultQuery = CarEntityQuery()

    let id: String

    @Property(title: "Locked")
    var isLocked: Bool

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "My iCar",
            subtitle: isLocked ? "Locked" : "Unlocked",
            image: .init(systemName: isLocked ? "car.side.lock.fill" : "car.side.lock.open.fill"),
        )
    }

    init(
        id: String = "my-icar",
        isLocked: Bool = true
    ) {
        self.id = id
        self.isLocked = isLocked
    }
}

struct CarEntityQuery: EntityQuery {
    @Dependency
    var store: CarStore

    @MainActor
    func entities(for identifiers: [CarEntity.ID]) async throws -> [CarEntity] {
        guard identifiers.contains("my-icar") else { return [] }
        return [makeEntity()]
    }

    @MainActor
    func suggestedEntities() async throws -> [CarEntity] {
        [makeEntity()]
    }

    @MainActor
    private func makeEntity() -> CarEntity {
        CarEntity(
            isLocked: store.load().isLocked
        )
    }
}
