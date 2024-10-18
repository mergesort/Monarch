@MainActor
final class MigrationContext {
    static let shared = MigrationContext()

    private var dependencies: [String: Any] = [:]

    private init() {}

    func register<Dependency>(_ dependency: Dependency) {
        let key = String(describing: Dependency.self)
        dependencies[key] = dependency
    }

    func resolve<Dependency>() -> Dependency {
        let key = String(describing: Dependency.self)
        guard let dependency = dependencies[key] as? Dependency else {
            fatalError("Dependency \(key) not found in MigrationContext.")
        }
        return dependency
    }
}
