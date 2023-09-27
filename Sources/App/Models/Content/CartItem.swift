//  Created by Maciej Gorecki on 27/09/2023.

import Foundation
import Vapor

struct CartItem: Content {
  let product: Product
  let quantity: Int
}
