//  Created by Maciej Gorecki on 16/09/2023.

import Foundation
import Vapor

struct Product: Content {
  enum ImageType: Equatable, Hashable, Codable {
    case local(String)
    case remote(URL)
  }

  let id: String
  let name: String

  let price: Double

  let hexColor: String
  let image: ImageType

  let availableSizes: [Int]

  let isLiked: Bool
}

extension Product {
  init?(_ product: DBProduct, imageURL: URL) {
    guard let id = product.id?.uuidString else { return nil }

    self.init(
      id: id,
      name: product.name,
      price: product.price,
      hexColor: product.hexColor,
      image: .remote(imageURL),
      availableSizes: product.availableSizes.sorted(),
      isLiked: product.isLiked
    )
  }
}
