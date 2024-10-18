import Monarch

final class NectarDependency {
    var hasDrankNectar = false
}

final class AfricanSwallowMigration: Migration {
    static let id = MigrationID("AfricanSwallowMigration")

    var hasRun = false

    func run() async throws {
        print("Running (flying) African Swallow migration")

        self.hasRun = true
    }
}

final class EuropeanSwallowMigration: Migration {
    static let id = MigrationID("EuropeanSwallowMigration")

    var hasRun = false

    func run() async throws {
        print("Running (flying) European Swallow migration")

        self.hasRun = true
    }
}

final class ButterflyMigration: Migration {
    static let id = MigrationID("ButterflyMigration")

    @MigrationDependency var dependency: NectarDependency

    var hasRun = false

    func run() async throws {
        print("Running (flying) Butterfly migration")

        self.hasRun = true
        self.dependency.hasDrankNectar = true
    }
}

final class FlamingoMigration: Migration {
    static let id: MigrationID = "FlamingoMigration"

    var hasRun = false

    func run() async throws {
        print("Running (flying) Flamingo migration")

        self.hasRun = true
    }
}
