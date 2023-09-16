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
    hexColor: "#FFD9D8",
    imageName: "nike1.png",
    availableSizes: [34, 35, 36, 37],
    isLiked: false
  )

  try await product1.create(on: app.db)
  try await product2.create(on: app.db)
}
