import Foundation
import UIKit

extension UIView {
  var centerOriginatedFrame: CGRect {
    get {
      .init(
        x: self.frame.origin.x + self.frame.size.width / 2,
        y: self.frame.origin.y + self.frame.size.height / 2,
        width: self.frame.width,
        height: self.frame.height
      )
    }
    set {
      self.frame = .init(
        x: newValue.origin.x - newValue.width / 2,
        y: newValue.origin.y - newValue.height / 2,
        width: newValue.width,
        height: newValue.height
      )
    }
  }
}
