//  Created by Maciej Gorecki on 16/09/2023.

import FluentKit
import Foundation
import Vapor

// TODO: Cleanup all of this
struct ProductController: RouteCollection {
  func boot(routes: Vapor.RoutesBuilder) throws {
    routes.get("products") { request async throws -> [Product] in
      do {
        let query = try await DBProduct.query(on: request.db).all()
        let products = try query.compactMap { product -> Product? in
          let imageURL = try request.imageURL(named: product.imageName)
          return Product(product, imageURL: imageURL)
        }

        return products
      } catch {
        return []
      }
    }

    routes.put("products", ":id", "like") { req in
      let id = req.parameters.get("id")!
      let uuid = UUID(uuidString: id)!

      let product = try await DBProduct.query(on: req.db)
        .filter(\.$id == uuid)
        .first()!

      product.isLiked = true

      try await product.update(on: req.db)

      let imageURL = try req.imageURL(named: product.imageName)

      guard let product = Product(product, imageURL: imageURL) else {
        struct CantCreateProductError: Error {}
        throw CantCreateProductError()
      }

      return product
    }

    routes.put("products", ":id", "dislike") { req in
      let id = req.parameters.get("id")!
      let uuid = UUID(uuidString: id)!

      let product = try await DBProduct.query(on: req.db)
        .filter(\.$id == uuid)
        .first()!

      product.isLiked = false

      try await product.update(on: req.db)

      let imageURL = try req.imageURL(named: product.imageName)

      guard let product = Product(product, imageURL: imageURL) else {
        struct CantCreateProductError: Error {}
        throw CantCreateProductError()
      }

      return product
    }
  }
}

private extension Request {
  func imageURL(named: String) throws -> URL {
    let hostname = application.http.server.configuration.hostname
    let port = application.http.server.configuration.port
    let baseURL = "http://\(hostname):\(port)/"
    let imagePath = "images/"
    let imageURL = baseURL + imagePath + named

    guard let url = URL(string: imageURL) else {
      struct InvalidURLError: Error {}
      throw InvalidURLError()
    }

    return url
  }
}
