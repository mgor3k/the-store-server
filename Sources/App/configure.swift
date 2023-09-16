import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
  app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

  let configuration: SQLPostgresConfiguration = .init(
    hostname: "localhost",
    port: 8080,
    username: "vapor",
    password: "vapor",
    database: "vapor",
    tls: .disable
  )

  app.databases.use(
    .postgres(
      configuration: configuration,
      encodingContext: .default,
      decodingContext: .default
    ),
    as: .psql
  )

  // register routes
  try routes(app)
}
