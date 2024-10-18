/// `MigrationDependency` provides a property wrapper for injecting dependencies into migrations.
@MainActor @propertyWrapper
public struct MigrationDependency<Value> {
    /// Initializes a new `MigrationDependency`.
    ///
    /// The actual value will be resolved when the property is accessed.
    public init() {}

    public var wrappedValue: Value {
        MigrationContext.shared.resolve()
    }
}
