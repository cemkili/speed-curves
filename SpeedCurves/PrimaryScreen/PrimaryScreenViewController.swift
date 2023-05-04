import UIKit

class PrimaryScreenViewController: UIViewController {
  let primaryScreenContainerView = PrimaryScreenContainerView()

  var primaryScreenContainerModel: PrimaryScreenVM? {
    didSet {
      self.primaryScreenContainerView.model = self.primaryScreenContainerModel
    }
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

// MARK: - Interactions

extension PrimaryScreenViewController {
  private func handleTapStartButton() {
    self.primaryScreenContainerModel?.isPlaying.toggle()
  }

  private func handleSliderValueChanged(value: Float) {
    guard let model = self.primaryScreenContainerModel else { return }
    print(value)
    print(model.projectImages.count)
    self.primaryScreenContainerModel?.currentMediaFrame = Int(Float(model.projectImages.count - 1) * value)
  }
}
