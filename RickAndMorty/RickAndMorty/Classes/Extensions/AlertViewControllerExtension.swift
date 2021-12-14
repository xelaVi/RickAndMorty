import UIKit

extension UIViewController {
  func showAlert(_ title: String, _ message: String, _ actions: [UIAlertAction]) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for action in actions {
      alert.addAction(action)
    }
    DispatchQueue.main.async {
      self.present(alert, animated: true)
    }
  }
}
