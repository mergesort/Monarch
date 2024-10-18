import Foundation

/// The `Migration` protocol defines the structure of Monarch's migrations.
///
/// Conforming types should provide an identifier and implement the migration logic.
@MainActor
public protocol Migration {
    /// A unique identifier for the migration.
    static var id: MigrationID { get }

    /// Executes the `Migration`. Provide your migration logic here.
    func run() async throws
}

// MARK: MigrationID

/// `MigrationID` represents a unique identifier for a migration.
///
/// This struct is used to identify and track individual migrations, and will be persisted by Monarch.
public struct MigrationID: Sendable, Equatable, ExpressibleByStringLiteral {
    private var encodedValue: String

    /// Initializes a new `MigrationID` with the given string value.
    ///
    /// - Parameter value: A string that uniquely identifies the migration.
    public init(_ value: String) {
        self.encodedValue = value
    }

    /// Initializes a new `MigrationID` from a string literal.
    ///
    /// - Parameter value: A string literal that uniquely identifies the migration.
    public init(stringLiteral value: String) {
        self.init(value)
    }

    internal var string: String {
        self.encodedValue
    }
}
