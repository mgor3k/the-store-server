import Vapor

func routes(_ app: Application) throws {
  app.get { req async in
    "It works!"
  }

  app.get("hello") { req async -> String in
    "Hello, world!"
  }

  app.get("products") { request async throws -> [Product] in
    let imageURL = try getImageURL(request, name: "nike1.png")

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

  func getImageURL(_ req: Request, name: String) throws -> URL {
    let hostname = req.application.http.server.configuration.hostname
    let port = req.application.http.server.configuration.port
    let baseURL = "http://\(hostname):\(port)/"
    let imageURL = "\(baseURL)\(name)"

    guard let url = URL(string: imageURL) else {
      struct InvalidURLError: Error {}
      throw InvalidURLError()
    }

    return url
  }
}
