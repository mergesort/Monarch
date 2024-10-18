import Foundation
import Testing
@testable import Monarch

@MainActor
@Suite("Migrations Tests")
struct MigrationTests {
    init() {
        MigrationRunner.removeAllMigrations()
    }

    @Test func migrationIDs() {
        let africanSwallowMigrationID: MigrationID = AfricanSwallowMigration.id
        let europeanSwallowMigrationID = EuropeanSwallowMigration.id

        #expect(africanSwallowMigrationID.string == AfricanSwallowMigration.id.string)
        #expect(europeanSwallowMigrationID.string == EuropeanSwallowMigration.id.string)
        #expect(africanSwallowMigrationID != europeanSwallowMigrationID)
    }

    @Test func migrationRunner() async throws {
        let flamingoMigration = FlamingoMigration()
        let migrationGroup = MigrationGroup {
            flamingoMigration
        }

        try await MigrationRunner.runMigrations(migrationGroup)

        #expect(flamingoMigration.hasRun)
    }

    @Test func migrationGroups() async throws {
        let africanSwallowMigration = AfricanSwallowMigration()
        let eurpoeanSwallowMigration = EuropeanSwallowMigration()

        let migrationGroup = MigrationGroup {
            africanSwallowMigration
            eurpoeanSwallowMigration
        }

        #expect(migrationGroup.migrations.count == 2)
        #expect(migrationGroup.migrations[0].testID == AfricanSwallowMigration.id)
        #expect(migrationGroup.migrations[1].testID == EuropeanSwallowMigration.id)

        #expect(!africanSwallowMigration.hasRun)
        #expect(!eurpoeanSwallowMigration.hasRun)

        try await MigrationRunner.runMigrations(migrationGroup)

        #expect(africanSwallowMigration.hasRun)
        #expect(eurpoeanSwallowMigration.hasRun)
    }

    @Test func migrationDependencies() async throws {
        let nectarDependency = NectarDependency()

        let butterflyMigration = ButterflyMigration()

        let migrationGroup = MigrationGroup {
            butterflyMigration
        }
        .migrationDependency(nectarDependency)

        try await MigrationRunner.runMigrations(migrationGroup)

        #expect(butterflyMigration.hasRun)

        #expect(butterflyMigration.dependency.hasDrankNectar)
        #expect(butterflyMigration.dependency.hasDrankNectar == nectarDependency.hasDrankNectar)
    }

    @Test func migrationBuilder() {
        let migrations = MigrationBuilder.buildBlock(
            AfricanSwallowMigration(),
            EuropeanSwallowMigration(),
            FlamingoMigration()
        )

        #expect(migrations.count == 3)
        #expect(migrations[0].testID == AfricanSwallowMigration.id)
        #expect(migrations[1].testID == EuropeanSwallowMigration.id)
        #expect(migrations[2].testID == FlamingoMigration.id)
    }
}

// MARK: Test Helpers

private extension Migration {
    var testID: MigrationID {
        type(of: self).id
    }
}
