import Foundation

struct Interpolation {
  static func linerInterpolate(x1: Decimal, y1: Decimal, x2: Decimal, y2: Decimal, x: Decimal) -> Decimal {
    let slope = (y2 - y1) / (x2 - x1)
    return y1 + slope * (x - x1)
  }
}
