import Foundation

/// `MigrationGroup` represents a collection of migrations to be executed together.
///
/// This struct allows you to group related migrations and manage them as a single unit.
/// It also provides functionality to register dependencies for the migrations.
@MainActor
public struct MigrationGroup {
    let migrations: [Migration]

    /// Initializes a new `MigrationGroup` with the provided migrations.
    public init(@MigrationBuilder _ migrations: () -> [Migration]) {
        self.migrations = migrations()
    }

    /// Registers a dependency for the migrations in this group.
    ///
    /// Use this method to provide any dependencies that your migrations might need.
    ///
    /// - Parameter dependency: The dependency to register.
    @discardableResult
    public func migrationDependency<Dependency>(_ dependency: Dependency) -> MigrationGroup {
        MigrationContext.shared.register(dependency)
        return self
    }
}
