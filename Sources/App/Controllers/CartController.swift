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

      var items: [CartItem] = []

      for item in query {
        guard let id = item.id, let uuid = UUID(uuidString: id) else { continue }

        let product = try? await DBProduct
          .query(on: req.db)
          .filter(\.$id == uuid)
          .first()

        guard
          let product,
          let imageURL = try? req.imageURL(named: product.imageName),
          let mappedProduct = Product(product, imageURL: imageURL) else {
          continue
        }

        let item = CartItem(
          product: mappedProduct,
          quantity: item.quantity
        )

        items.append(item)
      }

      return items
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
