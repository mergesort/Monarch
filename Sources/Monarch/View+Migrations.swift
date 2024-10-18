import SwiftUI

public extension View {
    /// Runs migrations when the view appears.
    ///
    /// - Parameter migrations: A closure that returns a configured `MigrationGroup`.
    func runMigrations(_ migrations: @escaping () -> MigrationGroup) -> some View {
        self.modifier(RunMigrationsModifier(migrations: migrations))
    }
}

// MARK: RunMigrationsModifier

private struct RunMigrationsModifier: ViewModifier {
    let migrations: () -> MigrationGroup

    func body(content: Content) -> some View {
        content
            .task {
                do {
                    try await MigrationRunner.runMigrations(self.migrations)
                } catch {
                    print("Migration failed with error: \(error)")
                }
            }
    }
}
