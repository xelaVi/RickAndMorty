import UIKit

extension UIViewController {
  /// Конфигурация смещения текстовых полей относительно клавиатуры
  /// -Parameters:
  ///  -moveDistance: Int
  ///  -goUp: Bool
  func moveView(moveDistance: Int, goUp: Bool) {
    let moveDuration = 0.3
    let movement = CGFloat(goUp ? moveDistance : -moveDistance)
    UIView.animate(withDuration: moveDuration, delay: 0, options: .beginFromCurrentState) {
      self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
    }
  }
}
