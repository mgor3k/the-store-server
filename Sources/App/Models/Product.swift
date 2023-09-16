//  Created by Maciej Gorecki on 16/09/2023.

import Foundation
import Vapor

public struct Product: Content {
  public enum ImageType: Equatable, Hashable, Codable {
    case local(String)
    case remote(URL)
  }

  public let id: String
  public let name: String

  public let price: Double

  public let hexColor: String
  public let image: ImageType

  public let availableSizes: [Int]

  public let isLiked: Bool
}
