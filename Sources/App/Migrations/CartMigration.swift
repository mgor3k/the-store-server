//  Created by Maciej Gorecki on 27/09/2023.

import Fluent
import Foundation

struct CartMigration: AsyncMigration {
  func prepare(on database: Database) async throws {
    try await database.schema("cart")
      .field("productId", .string)
      .field("quantity", .int)
      .create()
  }

  func revert(on database: Database) async throws {
    try await database.schema("cart")
      .delete()
  }
}
