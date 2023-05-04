import Foundation
import UIKit

class SecondaryScreenContainerView: UIView {
  let speedCurveView = SpeedCurveView()

  var didPanCurveCircles: ((CGPoint, CGPoint, CGPoint, CGRect) -> Void)? {
    get { self.speedCurveView.didPanCurveCircles }
    set { self.speedCurveView.didPanCurveCircles = newValue }
  }

  var model: SecondaryScreenVM? {
    didSet {
      self.update()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.setup()
    self.style()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    self.addSubview(self.speedCurveView)
  }

  private func style() {
    self.backgroundColor = .white
  }

  private func update() {
    guard let model = self.model else { return }
    self.speedCurveView.model = model.speedCurveModel

    self.setNeedsLayout()
    self.layoutIfNeeded()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    let speedCurveViewSize: CGSize = .init(width: self.bounds.width - 60, height: self.bounds.height * 0.3)
    self.speedCurveView.centerOriginatedFrame = .init(
      x: self.bounds.midX,
      y: self.bounds.maxY - speedCurveViewSize.height / 2 - self.safeAreaInsets.bottom - 20,
      width: speedCurveViewSize.width,
      height: speedCurveViewSize.height
    )

    self.speedCurveView.layer.cornerRadius = 8
  }
}

// MARK: - Model

struct SecondaryScreenVM {
  var speedCurveModel: SpeedCurveVM
}
