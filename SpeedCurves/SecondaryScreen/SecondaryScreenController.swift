import UIKit

class SecondaryScreenController: UIViewController {
  let secondaryScreenContainerView = SecondaryScreenContainerView()
  var secondaryScreenContainerModel = SecondaryScreenVM(
    speedCurveModel: .init(firstCurveSpeed: 1, middleCurveSpeed: 0.2, middleCurveXRatio: 0.5, lastCurveSpeed: 5)
  ) {
    didSet {
      self.secondaryScreenContainerView.model = self.secondaryScreenContainerModel
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setup()
  }

  private func setup() {
    self.view = secondaryScreenContainerView
    self.secondaryScreenContainerView.model = self.secondaryScreenContainerModel
    self.secondaryScreenContainerView.didPanCurveCircles = { [weak self] in
      self?.didPanCurveCircles(firstCurveCirclePosition: $0, middleCurveCirclePosition: $1, lastCurveCirclePosition: $2, safeAreaRect: $3)
    }
  }
}

// MARK: - Callbacks

extension SecondaryScreenController {
  func didPanCurveCircles(
    firstCurveCirclePosition: CGPoint,
    middleCurveCirclePosition: CGPoint,
    lastCurveCirclePosition: CGPoint,
    safeAreaRect: CGRect
  ) {
    let getSpeedFromPosition: (CGPoint) -> CGFloat = {
      let ratioY = 1 - (($0.y - safeAreaRect.origin.y) / safeAreaRect.height)

      if ratioY > 0.5 {
        return 1 + ((ratioY - 0.5) * 8)
      } else {
        return 0.2 + ratioY * 1.6
      }
    }
    self.secondaryScreenContainerModel.speedCurveModel = .init(
      firstCurveSpeed: getSpeedFromPosition(firstCurveCirclePosition),
      middleCurveSpeed: getSpeedFromPosition(middleCurveCirclePosition),
      middleCurveXRatio: (middleCurveCirclePosition.x - safeAreaRect.origin.x) / safeAreaRect.width,
      lastCurveSpeed: getSpeedFromPosition(lastCurveCirclePosition))
  }
}
