//  Created by Maciej Gorecki on 16/09/2023.

import Fluent
import Foundation
import Vapor

final class DBProduct: Content, Model {
  static let schema = "products"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "name")
  var name: String

  @Field(key: "price")
  var price: Double

  @Field(key: "hexColor")
  var hexColor: String

  @Field(key: "imageName")
  var imageName: String

  @Field(key: "availableSizes")
  var availableSizes: [Int]

  @Field(key: "isLiked")
  var isLiked: Bool

  required init() { }

  init(
    id: UUID? = nil,
    name: String,
    price: Double,
    hexColor: String,
    imageName: String,
    availableSizes: [Int],
    isLiked: Bool
  ) {
    self.id = id
    self.name = name
    self.price = price
    self.hexColor = hexColor
    self.imageName = imageName
    self.availableSizes = availableSizes
    self.isLiked = isLiked
  }
}
