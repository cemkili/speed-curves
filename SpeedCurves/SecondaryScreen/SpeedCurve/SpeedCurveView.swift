import Foundation
import UIKit

class SpeedCurveView: UIView {
  let firstCurveCircle = CurveCircle()
  let middleCurveCircle = CurveCircle()
  let lastCurveCircle = CurveCircle()

  var didPanCurveCircles: ((CGPoint, CGPoint, CGPoint, CGRect) -> Void)?

  override var safeAreaInsets: UIEdgeInsets {
    .init(top: 30, left: 40, bottom: 30, right: 40)
  }

  var model: SpeedCurveVM? {
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
    self.addSubview(self.firstCurveCircle)
    self.addSubview(self.middleCurveCircle)
    self.addSubview(self.lastCurveCircle)

    let firstCurveCirclePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    let middleCurveCirclePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    let lastCurveCirclePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))

    self.firstCurveCircle.addGestureRecognizer(firstCurveCirclePanGestureRecognizer)
    self.middleCurveCircle.addGestureRecognizer(middleCurveCirclePanGestureRecognizer)
    self.lastCurveCircle.addGestureRecognizer(lastCurveCirclePanGestureRecognizer)
  }

  private func style() {
    self.backgroundColor = .lightGray
  }

  private func update() {
    guard self.model != nil else { return }

    self.setNeedsLayout()
    self.layoutIfNeeded()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    guard let model = self.model else { return }

    let curveCircleSize: CGSize = .init(width: 30, height: 30)
    let safeAreaRect = self.bounds.inset(by: self.safeAreaInsets)

    self.firstCurveCircle.centerOriginatedFrame = .init(
      origin: safeAreaRect.origin + model.firstCurveCircleRelativePosition(containerSize: safeAreaRect.size),
      size: curveCircleSize
    )
    self.middleCurveCircle.centerOriginatedFrame = .init(
      origin: safeAreaRect.origin + model.middleCurveCircleRelativePosition(containerSize: safeAreaRect.size),
      size: curveCircleSize
    )
    self.lastCurveCircle.centerOriginatedFrame = .init(
      origin: safeAreaRect.origin + model.lastCurveCircleRelativePosition(containerSize: safeAreaRect.size),
      size: curveCircleSize
    )
  }
}

// MARK: - Actions

extension SpeedCurveView {
  @objc private func didPan(_ sender: UIPanGestureRecognizer) {
    let senderView = sender.view!
    let translation = sender.translation(in: senderView)
    let safeAreaRect = self.bounds.inset(by: self.safeAreaInsets)

    switch sender.state {
    case .began, .changed:
      // First and last curve circles can only move vertically
      if senderView == self.firstCurveCircle || senderView == self.lastCurveCircle {
        senderView.center = .init(x: senderView.center.x, y: (senderView.center.y + translation.y)).bounded(by: safeAreaRect)
      } else {
        // To prevent middle curve circle overlap with other circles we bound the position with another inset.
        senderView.center = .init(x: (senderView.center.x + translation.x),y: (senderView.center.y + translation.y))
          .bounded(by: safeAreaRect.inset(by: .init(top: 0, left: 40, bottom: 0, right: 40)))
      }
      sender.setTranslation(.zero, in: senderView)

    case .ended:
      self.didPanCurveCircles?(self.firstCurveCircle.center, self.middleCurveCircle.center, self.lastCurveCircle.center, safeAreaRect)

    default:
      break
    }
  }
}

// MARK: - Model

struct SpeedCurveVM {
  var firstCurveSpeed: Decimal
  var middleCurveSpeed: Decimal
  var middleCurveXRatio: Decimal
  var lastCurveSpeed: Decimal

  init(firstCurveSpeed: Decimal, middleCurveSpeed: Decimal, middleCurveXRatio: Decimal, lastCurveSpeed: Decimal) {
    self.firstCurveSpeed = firstCurveSpeed
    self.middleCurveSpeed = middleCurveSpeed
    self.middleCurveXRatio = middleCurveXRatio
    self.lastCurveSpeed = lastCurveSpeed
  }
}

extension SpeedCurveVM {
  fileprivate func firstCurveCircleRelativePosition(containerSize: CGSize) -> CGPoint {
    .init(x: 0, y: self.speedToRelativePositionY(speed: self.firstCurveSpeed, containerSize: containerSize))
  }

  fileprivate func middleCurveCircleRelativePosition(containerSize: CGSize) -> CGPoint {
    .init(
      x: containerSize.width * middleCurveXRatio.cgFloatValue,
      y: self.speedToRelativePositionY(speed: self.middleCurveSpeed, containerSize: containerSize)
    )
  }

  fileprivate func lastCurveCircleRelativePosition(containerSize: CGSize) -> CGPoint {
    .init(
      x: containerSize.width,
      y: self.speedToRelativePositionY(speed: self.lastCurveSpeed, containerSize: containerSize)
    )
  }

  private func speedToRelativePositionY(speed: Decimal, containerSize: CGSize) -> CGFloat {
    speed < 1
    ? containerSize.height * CGFloat(1 - (speed.floatValue - 0.2) / 0.2 / 8)
    : containerSize.height * CGFloat(1 - ((speed.floatValue - 1) / 8 + 0.5))
  }
}
