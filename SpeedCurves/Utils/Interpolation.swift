import Foundation

struct Interpolation {
  static func interpolate(x1: Float, y1: Float, x2: Float, y2: Float, x: Float) -> Float {
    let slope = (y2 - y1) / (x2 - x1)
    return y1 + slope * (x - x1)
  }
}
