@resultBuilder
public struct MigrationBuilder {
    public static func buildBlock(_ migrations: Migration...) -> [Migration] {
        return migrations
    }
}
