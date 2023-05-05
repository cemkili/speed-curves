import Foundation

extension Decimal {
  var floatValue: Float {
    Float(truncating: self as NSNumber)
  }

  var cgFloatValue: CGFloat {
    CGFloat(truncating: self as NSNumber)
  }
}
