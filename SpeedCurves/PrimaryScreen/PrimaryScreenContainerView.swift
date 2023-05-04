import Foundation
import UIKit

class PrimaryScreenContainerView: UIView {
  let player = PlayerView()
  let startButton = UIButton()
  let frameSliderHeaderLabel = UILabel()
  let frameSlider = UISlider()
  let currentProjectFrameLabel = UILabel()
  let currentMediaFrameLabel = UILabel()

  var handleTapStartButton: (() -> Void)?
  var handleSliderValueChanged: ((Float) -> Void)?

  var model: PrimaryScreenVM? {
    didSet {
      self.update(oldModel: oldValue)
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
    self.addSubview(self.player)
    self.addSubview(self.startButton)
    self.addSubview(self.frameSliderHeaderLabel)
    self.addSubview(self.frameSlider)
    self.addSubview(self.currentProjectFrameLabel)
    self.addSubview(self.currentMediaFrameLabel)

    self.startButton.addTarget(self, action: #selector(self.didTapStartButton), for: .touchUpInside)
    self.frameSlider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
  }

  private func style() {
    self.backgroundColor = .white
    self.startButton.setImage(UIImage(named: "pause-play-button"), for: .normal)
    self.frameSliderHeaderLabel.text = "Project frames slider"
    self.frameSliderHeaderLabel.textColor = .black
    self.currentProjectFrameLabel.textColor = .black
    self.currentMediaFrameLabel.textColor = .black

    self.frameSlider.tintColor = UIColor.green
  }

  private func update(oldModel: PrimaryScreenVM?) {
    guard let model = self.model else { return }

    if model.projectImages != oldModel?.projectImages {
      self.player.setImages(images: model.projectImages)
    }

    if model.currentMediaFrame != oldModel?.currentMediaFrame {
      self.currentMediaFrameLabel.text = "Current media frame: \(model.currentMediaFrame)"
    }

    if model.currentProjectFrame != oldModel?.currentProjectFrame {
      self.currentProjectFrameLabel.text = "Current project frame: \(model.currentProjectFrame)"
      self.player.setCurrentFrame(frame: model.currentProjectFrame)
    }

    if model.isPlaying && oldModel?.isPlaying == false {
      self.player.play()
    } else if !model.isPlaying && oldModel?.isPlaying == true {
      self.player.stop()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let horizontalMargin: CGFloat = 20

    let playerSize: CGSize = .init(width: self.bounds.width - 2 * horizontalMargin, height: self.bounds.height * 0.4)
    self.player.centerOriginatedFrame = .init(
      x: self.bounds.midX,
      y: self.bounds.minY + playerSize.height / 2 + self.safeAreaInsets.top + 20,
      width: playerSize.width,
      height: playerSize.height
    )
    self.player.layer.cornerRadius = 8

    let startButtonSize: CGSize = .init(width: 40, height: 40)
    self.startButton.centerOriginatedFrame = .init(
      x: self.bounds.midX,
      y: self.player.frame.maxY + startButtonSize.height / 2 + 10,
      width: startButtonSize.width,
      height: startButtonSize.height
    )

    let labelSize: CGSize = .init(width: self.bounds.width - 2 * horizontalMargin, height: 30)

    self.frameSliderHeaderLabel.centerOriginatedFrame = .init(
      x: self.bounds.midX,
      y: self.startButton.frame.maxY + labelSize.height / 2 + 20,
      width: labelSize.width,
      height: labelSize.height
    )

    let frameSliderSize: CGSize = .init(width: self.bounds.width - 2 * horizontalMargin, height: 40)
    self.frameSlider.centerOriginatedFrame = .init(
      x: self.bounds.midX,
      y: self.frameSliderHeaderLabel.frame.maxY + frameSliderSize.height / 2 + 20,
      width: frameSliderSize.width,
      height: frameSliderSize.height
    )

    self.currentProjectFrameLabel.centerOriginatedFrame = .init(
      x: self.bounds.midX,
      y: self.frameSlider.frame.maxY + labelSize.height / 2 + 20,
      width: labelSize.width,
      height: labelSize.height
    )

    self.currentMediaFrameLabel.centerOriginatedFrame = .init(
      x: self.bounds.midX,
      y: self.currentProjectFrameLabel.frame.maxY + labelSize.height / 2,
      width: labelSize.width,
      height: labelSize.height
    )
  }
}

// MARK: - Interactions

extension PrimaryScreenContainerView {
  @objc func didTapStartButton() {
    self.handleTapStartButton?()
  }

  @objc func sliderValueDidChange(_ sender:UISlider!) {
    self.handleSliderValueChanged?(sender.value)
  }
}

// MARK: - Model

struct PrimaryScreenVM {
  var projectImages: [UIImage]
  var isPlaying: Bool
  var currentProjectFrame: Int
  var currentMediaFrame: Int
}
