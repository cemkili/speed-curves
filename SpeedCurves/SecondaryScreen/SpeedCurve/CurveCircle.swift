import Foundation
import UIKit

extension SpeedCurveView {
  class CurveCircle: UIView {
    override init(frame: CGRect) {
      super.init(frame: frame)

      self.style()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    private func style() {
      self.backgroundColor = .darkGray
      self.layer.borderColor = UIColor.black.cgColor
      self.layer.borderWidth = 1
    }

    override func layoutSubviews() {
      super.layoutSubviews()

      self.layer.cornerRadius = self.bounds.width / 2
    }
  }
}
