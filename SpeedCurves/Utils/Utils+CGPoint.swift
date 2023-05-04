import Foundation

extension CGPoint {
  static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
      return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }

  func bounded(by rect: CGRect) -> Self {
    .init(
      x: self.x.bounded(lowest: rect.minX, highest: rect.maxX),
      y: self.y.bounded(lowest: rect.minY, highest: rect.maxY)
    )
  }
}
