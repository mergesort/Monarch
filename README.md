# Monarch 🦋

#### Minimal, Manageable, Migrations

![Photo of many Monarch butterflies](Images/monarch.jpg)

#### Running migrations in your app has never been easier: inspired by the migratory Monarch butterfly.

For a more detailed introduction to Monarch, check out my blog post [introducing Monarch](https://build.ms/2024/10/23/minimal-manageable-migrations-with-monarch).

---

You don’t always get it right the first time. That’s why pencils have erasers — and why apps have migrations.

- **Simple Migrations**: Define independent migrations without worrying about state management, making it easy to evolve your app over time.

- **Built for Swift and SwiftUI**: Monarch’s migrations feel right at home in any Swift app, with a clean SwiftUI API.

- **Dependency Injection**: Whether your migration is simple or complex, Monarch’s easy-to-use dependency injection provides structure to prevent data-related issues.

### Getting Started

Setting up migrations in your app is simple:

1. **Define your migrations** using the `Migration` protocol.
2. **Add your migrations** to a `MigrationGroup`.
3. **Run your migrations** using the `runMigrations` view modifier.

```swift
// 1. Define a migration
struct MigrateAuthTokenToKeychain: Migration {
    @MigrationDependency private var userDefaultsAppState
    @MigrationDependency private var keychainAppState

    static let id: MigrationID = "MigrateAuthTokenToKeychain"

    func run() async throws {
        // Migrate the auth token that should have never been stored in UserDefaults over to the Keychain 😱
        keychainAppState.authToken = userDefaultsAppState.authToken

        userDefaultsAppState.authToken = nil
    }
}
```

```swift
// 2. Group your migrations and add dependencies
let migrations = MigrationGroup {
    MigrateAuthTokenToKeychain()
    // Add more migrations here
}
.migrationDependency(self.userDefaultsAppState)
.migrationDependency(self.keychainAppState)
```

```swift
// 3. Run migrations in your SwiftUI app
struct ContentView: View {
    var body: some View {
        Text("Hello, Monarch! 🦋")
            .runMigrations {
                migrations
            }
    }
}
```

That’s all you need to get started with Monarch! Add as many migrations and dependencies as needed to help evolve your app over time.

### Advanced Usage

Monarch offers various ways to customize and control your migration process:

#### Manually run migrations

If the timing of migrations is crucial in your app, you can use the `MigrationRunner` for full control. Here’s an example of an app that leverages Monarch’s functionality to manually run migrations:

```swift
struct ButterflyTrackerApp: App {
    @State var appState = AppState()
    @State var preferences = Preferences()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task { 
						try await self.runMigrations()
                }
        }
    }
    
	func runMigrations() async throws {
        MigrationRunner.removeAllMigrations()

        MigrationRunner.markMigrationAsCompleted(withID: ResetButterflyListMigration.id)
        
        let migrationGroup = MigrationGroup {
            ProvideButterlyFansPremiumAccountAccessMigration()
            RemoveAccidentallyAddedMothMigration()
        }
        .migrationDependency(self.appState)
        .migrationDependency(self.preferences)

        try await MigrationRunner.runMigrations({ migrationGroup })
    }
}
```

#### MigrationRunner API

```swift
// Run the migrations in a MigrationGroup.
public static func runMigrations(_ migrationGroup: MigrationGroup) async throws

// Mark a migration as completed, without actually running it. This is useful when transitioning to Monarch from another migration system.
public static func markMigrationAsCompleted(withID id: MigrationID)

// Remove a specific migration that has previously run, allowing it to be re-run.
public static func removeMigration(withID id: MigrationID)

// Remove all previously run migrations.
public static func removeAllMigrations()
```

> [!NOTE]
> Monarch stores its list of completed migrations in UserDefaults, which can take up to 7 seconds to synchronize. If the user re-runs these migrations within this 7-second window, such as by relaunching the app, migrations *may* be re-run.


### Requirements

- iOS 17.0+
- macOS 14.0+
- Xcode 14+
- Swift 5.10+

### Installation

#### Swift Package Manager

Add Monarch as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/Monarch.git", .upToNextMajor(from: "1.0.0"))
]
```

Then, add Monarch to your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["Monarch"]
    )
]
```

#### Manually

If you prefer not to use SPM, you can integrate Monarch into your project manually by copying the files from the `Sources/Monarch` directory.

---

### About me

Hi, I'm [Joe](http://fabisevi.ch) everywhere on the web, but especially on [Threads](https://threads.net/@mergesort).

### License

See the [license](LICENSE) for more information about how you can use Monarch.

### Sponsorship

Monarch is a labor of love to help developers build better apps, making it easier for you to unlock your creativity and make something amazing for your yourself and your users. If you find Monarch valuable I would really appreciate it if you'd consider helping [sponsor my open source work](https://github.com/sponsors/mergesort), so I can continue to work on projects like Monarch to help developers like yourself.
