@resultBuilder
public struct MigrationBuilder {
    public static func buildBlock(_ migrations: Migration...) -> [Migration] {
        return migrations
    }

	public static func buildBlock(_ migrations: [Migration]...) -> [Migration] {
		migrations.flatMap { $0 }
	}

	public static func buildExpression(_ expression: Migration) -> [Migration] {
		[expression]
	}

	public static func buildExpression(_ expression: [Migration]) -> [Migration] {
		expression
	}

	public static func buildOptional(_ migration: [Migration]?) -> [Migration] {
		migration ?? []
	}

	public static func buildEither(first migration: [Migration]) -> [Migration] {
		migration
	}

	public static func buildEither(second migration: [Migration]) -> [Migration] {
		migration
	}

	public static func buildArray(_ migrations: [[Migration]]) -> [Migration] {
		migrations.flatMap { $0 }
	}

	public static func buildLimitedAvailability(_ migration: [Migration]) -> [Migration] {
		migration
	}

}
