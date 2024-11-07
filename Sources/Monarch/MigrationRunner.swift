import Foundation

/// `MigrationRunner` provides a for running and managing migrations in your app.
@MainActor
public struct MigrationRunner {
    private static var completedMigrations: Set<String> = Set(
        UserDefaults.standard.array(forKey: UserDefaults.completedMigrationsKey) as? [String] ?? []
    )

    private init() {}

    /// Runs all migrations in the provided `MigrationGroup` that are not yet complete.
    ///
    /// This function iterates through the migrations in the given group, executes each
    /// uncompleted migration, and marks it as completed upon successful execution.
    ///
    /// - Parameter migrationGroup: The group of migrations to run.
    /// - Throws: Any error that occurs during the execution of a migration.
    public static func runMigrations(_ migrationGroup: MigrationGroup) async throws {
        var completedMigrations = Self.completedMigrations

        for migration in migrationGroup.migrations {
            guard !completedMigrations.contains(type(of: migration).id.string) else { continue }

            // Run the migration
            try await migration.run()

            // Mark the migration as completed
            completedMigrations.insert(type(of: migration).id.string)
        }

        self.updateCompletedMigrations(completedMigrations)
    }

    /// Runs all migrations in the provided `MigrationGroup` that are not yet complete.
    ///
    /// This function iterates through the migrations in the given group, executes each
    /// uncompleted migration, and marks it as completed upon successful execution.
    ///
    /// - Parameter migrationGroup: The group of migrations to run.
    /// - Throws: Any error that occurs during the execution of a migration.
    public static func runMigrations(_ migrations: () -> MigrationGroup) async throws {
        try await self.runMigrations(migrations())
    }

    /// Marks a specific `Migration` as completed without running it.
    ///
    /// This function is useful when you want to skip a migration or manually
    /// mark a `Migration` as completed.
    ///
    /// - Parameter id: The ID of the `Migration` to mark as completed.
    public static func markMigrationAsCompleted(withID id: MigrationID) {
        var completedMigrations: Set<String> = Self.completedMigrations

        completedMigrations.insert(id.string)

        self.updateCompletedMigrations(completedMigrations)
    }

    /// Removes a specific `Migration` from the list of completed migrations.
    ///
    /// This function is useful when you want to re-run a `Migration` that was
    /// previously marked as completed.
    ///
    /// - Parameter id: The ID of the migration to remove from the completed list.
    public static func removeMigration(withID id: MigrationID) {
        var completedMigrations: Set<String> = Self.completedMigrations

        completedMigrations.remove(id.string)

        self.updateCompletedMigrations(completedMigrations)
    }

    /// Removes all migrations from the list of completed migrations.
    ///
    /// This function clears the entire record of completed migrations, effectively
    /// resetting the migration state of the application.
    public static func removeAllMigrations() {
        self.updateCompletedMigrations([])
    }
}

private extension MigrationRunner {
    static func updateCompletedMigrations(_ completedMigrationIDs: Set<String>) {
        Self.completedMigrations = completedMigrationIDs
        UserDefaults.standard.set(Array(completedMigrationIDs), forKey: UserDefaults.completedMigrationsKey)
    }
}

// MARK: UserDefaults

private extension UserDefaults {
    static let completedMigrationsKey = "com.migrations.Monarch.completed"
}
