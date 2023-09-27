//  Created by Maciej Gorecki on 16/09/2023.

import Fluent
import Foundation

struct ProductMigration: AsyncMigration {
  func prepare(on database: Database) async throws {
    try await database.schema("products")
      .id()
      .field("name", .string)
      .field("price", .double)
      .field("hexColor", .string)
      .field("imageName", .string)
      .field("availableSizes", .array(of: .int))
      .field("isLiked", .bool)
      .create()
  }

  func revert(on database: Database) async throws {
    try await database.schema("products")
      .delete()
  }
}
