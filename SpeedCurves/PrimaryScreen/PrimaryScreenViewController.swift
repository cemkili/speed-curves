import UIKit

class PrimaryScreenViewController: UIViewController {
  let primaryScreenContainerView = PrimaryScreenContainerView()

  var mediaImages: [UIImage]
  var speedCurveModel: SpeedCurveVM {
    didSet {
      self.primaryScreenContainerModel?.projectImages = self.projectImages
    }
  }

  var primaryScreenContainerModel: PrimaryScreenVM? {
    get { self.primaryScreenContainerView.model }
    set { self.primaryScreenContainerView.model = newValue }
  }

  init(mediaImages: [UIImage], speedCurveModel: SpeedCurveVM) {
    self.mediaImages = mediaImages
    self.speedCurveModel = speedCurveModel

    super.init(nibName: nil, bundle: nil)

    self.primaryScreenContainerModel = .init(
      projectImages: self.projectImages,
      isPlaying: false,
      currentProjectFrame: 0,
      currentMediaFrame: 0
    )
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setup()
  }

  private func setup() {
    self.view = primaryScreenContainerView
    self.primaryScreenContainerView.model = self.primaryScreenContainerModel
    self.primaryScreenContainerView.handleTapStartButton = { [weak self] in
      self?.handleTapStartButton()
    }

    self.primaryScreenContainerView.handleSliderValueChanged = { [weak self] in
      self?.handleSliderValueChanged(value: $0)
    }
  }
}

extension PrimaryScreenViewController {
  fileprivate var projectImages: [UIImage] {
    let numberOfIntegersBetween: (Float, Float) -> Int  = {
      let start = Int(floor($0))
      let end = Int(floor($1))
      return end - start + ((Float(start) == $0) ? 1 : 0) + ((Float(end) == $1) ? -1 : 0)
    }

    var result: [UIImage] = []
    var totalFrame: Decimal = 0
    for frame in 0..<self.mediaImages.count {
      let startFrame = totalFrame
      let speed = self.speedCurveModel.interpolateSpeed(forMedia: frame, mediaImageCount: self.mediaImages.count)
      let inverseSpeed = 1 / speed
      let endFrame = totalFrame + inverseSpeed
      let count = numberOfIntegersBetween(startFrame.floatValue, endFrame.floatValue)
      result += Array(repeating: self.mediaImages[frame], count: count)
      totalFrame = endFrame
    }

    return result
  }
}

// MARK: - Interactions

extension PrimaryScreenViewController {
  private func handleTapStartButton() {
    self.primaryScreenContainerModel?.isPlaying.toggle()
  }

  private func handleSliderValueChanged(value: Float) {
    guard let model = self.primaryScreenContainerModel else { return }

    self.primaryScreenContainerModel?.isPlaying = false
    self.primaryScreenContainerModel?.currentProjectFrame = Int((Float(model.projectImages.count - 1) * value).rounded())
    //self.primaryScreenContainerModel?.currentMediaFrame =
  }
}

extension SpeedCurveVM {
  fileprivate func interpolateSpeed(forMedia x: Int, mediaImageCount: Int) -> Decimal {
    let lastMediaFrame = Decimal(mediaImageCount - 1)
    let mediaAtMiddleCurveCircle = lastMediaFrame * self.middleCurveXRatio
    if Decimal(x) < mediaAtMiddleCurveCircle {
      return Interpolation.linerInterpolate(
        x1: 0,
        y1: self.firstCurveSpeed,
        x2: mediaAtMiddleCurveCircle,
        y2: self.middleCurveSpeed,
        x: Decimal(x)
      )
    } else {
      return Interpolation.linerInterpolate(
        x1: mediaAtMiddleCurveCircle,
        y1: self.middleCurveSpeed,
        x2: lastMediaFrame,
        y2: self.lastCurveSpeed,
        x: Decimal(x)
      )
    }
  }
}
