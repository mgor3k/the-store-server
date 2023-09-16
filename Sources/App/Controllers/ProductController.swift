//  Created by Maciej Gorecki on 16/09/2023.

import Foundation
import Vapor

struct ProductController: RouteCollection {
  func boot(routes: Vapor.RoutesBuilder) throws {
    routes.get("products") { request async throws -> [Product] in
      let imageURL = try request.imageURL(named: "nike1.png")

      let products: [Product] = [
        .init(
          id: "1",
          name: "Nike Air Pegasus",
          price: 250.40,
          hexColor: "#FFD9D8",
          image: .remote(imageURL),
          availableSizes: [34, 35, 36, 37],
          isLiked: true
        )
      ]

      return products
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
