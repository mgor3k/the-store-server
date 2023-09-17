//  Created by Maciej Gorecki on 16/09/2023.

import FluentKit
import Foundation
import Vapor

struct ProductController: RouteCollection {
  enum Error: Swift.Error {
    case buildProduct
  }

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

private extension Request {
  enum Error: Swift.Error {
    case invalidURL
    case missingID
    case initUUID
    case noProduct
  }

  func imageURL(named: String) throws -> URL {
    let hostname = application.http.server.configuration.hostname
    let port = application.http.server.configuration.port
    let baseURL = "http://\(hostname):\(port)/"
    let imagePath = "images/"
    let imageURL = baseURL + imagePath + named

    guard let url = URL(string: imageURL) else {
      throw Error.invalidURL
    }

    return url
  }

  func queryProduct(idParam: String) async throws -> DBProduct {
    guard let id = parameters.get(idParam) else {
      throw Error.missingID
    }

    guard let uuid = UUID(uuidString: id) else {
      throw Error.initUUID
    }

    let product = try await DBProduct.query(on: db)
      .filter(\.$id == uuid)
      .first()

    guard let product else {
      throw Error.noProduct
    }

    return product
  }
}
