//  Created by Maciej Gorecki on 16/09/2023.

import Foundation
import Vapor

func mocks(_ app: Application) async throws {
  let query = try await DBProduct.query(on: app.db).all()
  guard query.isEmpty else { return }

  let product1 = DBProduct(
    name: "Nike Air Pegasus",
    price: 250.40,
    hexColor: "#FFD9D8",
    imageName: "nike1.png",
    availableSizes: [34, 35, 36, 37],
    isLiked: false
  )

  let product2 = DBProduct(
    name: "Nike Air Pegasus",
    price: 250.40,
    hexColor: "#DBE3E6",
    imageName: "nike2.png",
    availableSizes: [34, 35, 36, 37],
    isLiked: false
  )

  let product3 = DBProduct(
    name: "Nike Air Max",
    price: 99.29,
    hexColor: "FFD9DD",
    imageName: "nike3.png",
    availableSizes: [22, 38, 40, 41, 42, 43, 44],
    isLiked: false
  )

  try await product1.create(on: app.db)
  try await product2.create(on: app.db)
  try await product3.create(on: app.db)
}
