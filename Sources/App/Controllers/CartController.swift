//  Created by Maciej Gorecki on 23/09/2023.

import FluentKit
import Foundation
import Vapor

struct CartController: RouteCollection {
  enum Error: Swift.Error {
    case missingProductId
  }

  func boot(routes: RoutesBuilder) throws {
    routes.get("cart") { req in
      let query = try await DBCartItem.query(on: req.db).all()

      return query.count
    }

    routes.post("cart", ":id") { req in
      struct Query: Content {
        let quantity: Int
      }

      guard let productId = req.parameters.get("id") else {
        throw Error.missingProductId
      }

      let query = try? req.query.decode(Query.self)
      let quantity = query?.quantity ?? 1

      if let existingProduct = try? await DBCartItem.find(productId, on: req.db) {
        if quantity == 0 {
          try await existingProduct.delete(on: req.db)
          return HTTPStatus.ok
        }
        existingProduct.quantity = quantity
        try await existingProduct.save(on: req.db)
        return HTTPStatus.ok
      }

      let item = DBCartItem(
        productId: productId,
        quantity: query?.quantity ?? 1
      )

      try await item.create(on: req.db)

      return HTTPStatus.ok
    }
  }
}
