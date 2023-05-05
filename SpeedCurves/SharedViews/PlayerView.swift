import Foundation
import UIKit

class PlayerView: UIImageView {
  private var timer: Timer?
  @MainActor private var currentFrame = 0
  @MainActor private var images: [UIImage] = []

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

  func play() {
    self.timer = Timer.scheduledTimer(withTimeInterval: 1/30, repeats: true) { [weak self] timer in
      guard let self = self, self.images.count > 0 else { return }
      self.currentFrame += 1

      if self.currentFrame >= self.images.count {
        self.currentFrame = 0
      }

      self.image = images[self.currentFrame]
    }
  }

  func stop() {
    self.timer?.invalidate()
    self.timer = nil
  }

  func setImages(images: [UIImage]) {
    self.images = images
    self.currentFrame = 0
  }

  func setCurrentFrame(frame: Int) {
    guard frame < images.count, frame >= 0 else { return }
    self.currentFrame = frame
    self.image = images[frame]
  }
}
