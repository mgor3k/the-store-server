//  Created by Maciej Gorecki on 23/09/2023.

import FluentKit
import Foundation
import Vapor

struct CartController: RouteCollection {
  enum Error: Swift.Error {
    case userIdNotFound
  }

  func boot(routes: RoutesBuilder) throws {
    routes.get("cart") { req in
      guard let user = req.headers.first(name: "user") else {
        throw Error.userIdNotFound
      }

      return HTTPStatus.ok
    }
  }
}
