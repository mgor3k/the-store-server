//  Created by Maciej Gorecki on 16/09/2023.

import Foundation
import Vapor

struct ProductController: RouteCollection {
  func boot(routes: Vapor.RoutesBuilder) throws {
    routes.get("products") { request async throws -> [Product] in
      do {
        let query = try await DBProduct.query(on: request.db).all()
        let products = try query.compactMap { product -> Product? in
          guard let id = product.id?.uuidString else { return nil }

          let imageName = try request.imageURL(named: product.imageName)

          return Product(
            id: id,
            name: product.name,
            price: product.price,
            hexColor: product.hexColor,
            image: .remote(imageName),
            availableSizes: product.availableSizes.sorted(),
            isLiked: product.isLiked
          )
        }

        return products
      } catch {
        return []
      }
    }
  }
}

private extension Request {
  func imageURL(named: String) throws -> URL {
    let hostname = application.http.server.configuration.hostname
    let port = application.http.server.configuration.port
    let baseURL = "http://\(hostname):\(port)/"
    let imageURL = "\(baseURL)\(named)"

    guard let url = URL(string: imageURL) else {
      struct InvalidURLError: Error {}
      throw InvalidURLError()
    }

    return url
  }
}
