import UIKit

extension UIViewController {
  func addGestureRecognizer(action: Selector) {
    let gesture = UITapGestureRecognizer(target: self, action: action)
    gesture.numberOfTouchesRequired = 1
    gesture.numberOfTapsRequired = 1
    self.view.addGestureRecognizer(gesture)
  }
}
