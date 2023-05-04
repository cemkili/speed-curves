import Foundation

extension CGFloat {
  func bounded(lowest: Self, highest: Self) -> Self {
    .minimum(.maximum(lowest, self), highest)
  }
}
