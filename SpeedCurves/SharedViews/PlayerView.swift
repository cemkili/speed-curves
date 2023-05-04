import Foundation
import UIKit

class PlayerView: UIImageView {
  private var timer: Timer?
  private var currentFrame: Int?
  private var images: [UIImage]?

  convenience init() {
    self.init(frame: .zero)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.style()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func style() {
    self.backgroundColor = .systemGray
    self.contentMode = .scaleAspectFit
    self.layer.cornerRadius = 16
  }

  func setImages(images: [UIImage]) {
    self.images = images
  }

  func play() {
    self.timer = Timer.scheduledTimer(withTimeInterval: 1/30, repeats: true) { [weak self] timer in
      guard let self = self,
            let currentFrame = self.currentFrame,
            let images = self.images
      else { return }

      if currentFrame >= images.count - 1 {
        self.setCurrentFrame(frame: 0)
      } else {
        self.setCurrentFrame(frame: currentFrame + 1)
      }
    }
  }

  func stop() {
    self.timer?.invalidate()
    self.timer = nil
  }

  func setCurrentFrame(frame: Int) {
    guard let images = self.images,
          frame < images.count,
          frame >= 0
    else { return }
    self.currentFrame = frame
    self.image = images[frame]
  }
}
