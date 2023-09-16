import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
  app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

  app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

  app.migrations.add(CreateProductMigration())

  // register routes
  try routes(app)

  // create mocks if needed
  try? await mocks(app)
}
