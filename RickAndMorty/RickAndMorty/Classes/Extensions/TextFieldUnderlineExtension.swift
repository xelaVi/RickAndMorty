import UIKit

extension UITextField {
  /// Добавление линии для текстовых полей
  /// -Parameter textField: UITextField
  func textFieldUnderLine() {
    let bottomLine = CALayer()
    let lineWidth = CGFloat(1.0)
    let hight = self.frame.height
    let width = self.frame.width
    bottomLine.frame = CGRect(x: 1, y: hight - lineWidth, width: width - 2, height: lineWidth)
    bottomLine.backgroundColor = CustomColors.border.withAlphaComponent(0.3).cgColor
    self.borderStyle = .none
    self.layer.addSublayer(bottomLine)
    self.layer.masksToBounds = true
  }
}
