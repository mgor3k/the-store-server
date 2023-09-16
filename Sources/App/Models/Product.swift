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
