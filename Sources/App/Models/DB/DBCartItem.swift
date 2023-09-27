//  Created by Maciej Gorecki on 23/09/2023.

import Fluent
import Foundation

final class DBCartItem: Model {
  static let schema = "cart"

  @ID(custom: "productId", generatedBy: .user)
  var id: String?

  @Field(key: "quantity")
  var quantity: Int

  required init() {}

  init(
    productId: String,
    quantity: Int
  ) {
    self.id = productId
    self.quantity = quantity
  }
}
