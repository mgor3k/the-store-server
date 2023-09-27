//  Created by Maciej Gorecki on 16/09/2023.

import FluentKit
import Foundation
import Vapor

struct ProductController: RouteCollection {
  enum Error: Swift.Error {
    case buildProduct
  }

  func boot(routes: Vapor.RoutesBuilder) throws {
    routes.get("products") { req async throws -> [Product] in
      do {
        let query = try await DBProduct.query(on: req.db).all()
        let products = try query.compactMap { product -> Product? in
          let imageURL = try req.imageURL(named: product.imageName)
          return Product(product, imageURL: imageURL)
        }

        return products
      } catch {
        return []
      }
    }

    routes.put("products", ":id", "like") { req in
      let product = try await req.queryProduct(idParam: "id")
      product.isLiked = true

      try await product.update(on: req.db)

      let imageURL = try req.imageURL(named: product.imageName)

      guard let product = Product(product, imageURL: imageURL) else {
        throw Error.buildProduct
      }

      return product
    }

    routes.put("products", ":id", "dislike") { req in
      let product = try await req.queryProduct(idParam: "id")
      product.isLiked = false

      try await product.update(on: req.db)

      let imageURL = try req.imageURL(named: product.imageName)

      guard let product = Product(product, imageURL: imageURL) else {
        throw Error.buildProduct
      }

      return product
    }
  }
}
