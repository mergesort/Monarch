import Foundation

/// `MigrationRunner` provides a for running and managing migrations in your app.
@MainActor
public struct MigrationRunner {
    private init() {}

    /// Runs all migrations in the provided `MigrationGroup` that are not yet complete.
    ///
    /// This function iterates through the migrations in the given group, executes each
    /// uncompleted migration, and marks it as completed upon successful execution.
    ///
    /// - Parameter migrationGroup: The group of migrations to run.
    /// - Throws: Any error that occurs during the execution of a migration.
    public static func runMigrations(_ migrationGroup: MigrationGroup) async throws {
        var completedMigrations = Set(
            UserDefaults.standard.array(forKey: UserDefaults.completedMigrationsKey) as? [String] ?? []
        )

        for migration in migrationGroup.migrations {
            guard !completedMigrations.contains(type(of: migration).id.string) else {
                continue
            }

            // Run the migration
            try await migration.run()

            // Mark the migration as completed
            completedMigrations.insert(type(of: migration).id.string)
        }

        let updatedMigrationsList = Array(completedMigrations)
        UserDefaults.standard.set(updatedMigrationsList, forKey: UserDefaults.completedMigrationsKey)
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
        var completedMigrations = Set(
            UserDefaults.standard.array(forKey: UserDefaults.completedMigrationsKey) as? [String] ?? []
        )

        completedMigrations.insert(id.string)

        let updatedMigrationsList = Array(completedMigrations)
        UserDefaults.standard.set(updatedMigrationsList, forKey: UserDefaults.completedMigrationsKey)
    }

    /// Removes a specific `Migration` from the list of completed migrations.
    ///
    /// This function is useful when you want to re-run a `Migration` that was
    /// previously marked as completed.
    ///
    /// - Parameter id: The ID of the migration to remove from the completed list.
    public static func removeMigration(withID id: MigrationID) {
        var completedMigrations = Set(
            UserDefaults.standard.array(forKey: UserDefaults.completedMigrationsKey) as? [String] ?? []
        )

        completedMigrations.remove(id.string)

        let updatedMigrationsList = Array(completedMigrations)
        UserDefaults.standard.set(updatedMigrationsList, forKey: UserDefaults.completedMigrationsKey)
    }

    /// Removes all migrations from the list of completed migrations.
    ///
    /// This function clears the entire record of completed migrations, effectively
    /// resetting the migration state of the application.
    public static func removeAllMigrations() {
        UserDefaults.standard.removeObject(forKey: UserDefaults.completedMigrationsKey)
    }
}

// MARK: UserDefaults

private extension UserDefaults {
    static let completedMigrationsKey = "com.migrations.Monarch.completed"
}
