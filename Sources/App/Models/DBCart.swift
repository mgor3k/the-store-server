//  Created by Maciej Gorecki on 23/09/2023.

import Fluent
import Foundation

final class DBCart: Model {
  static let schema = "cart"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "userID")
  var userID: String

  @Field(key: "items")
  var items: [DBCartItem]

  required init() { }

  init(
    id: UUID? = nil,
    userID: String,
    items: [DBCartItem]
  ) {
    self.id = id
    self.userID = userID
    self.items = items
  }
}

final class DBCartItem: Model {
  static let schema = "cart"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "productID")
  var productID: String

  @Field(key: "quantity")
  var quantity: Int

  required init() {}

  init(
    id: UUID? = nil,
    productID: String,
    quantity: Int
  ) {
    self.id = id
    self.productID = productID
    self.quantity = quantity
  }
}
