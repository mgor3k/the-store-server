//  Created by Maciej Gorecki on 27/09/2023.

import Fluent
import Foundation
import Vapor

extension Request {
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
