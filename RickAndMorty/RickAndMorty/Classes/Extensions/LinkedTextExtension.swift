import UIKit

extension String {
  /// Создание ссылок на определенные части текста
  /// -Parameters:
  ///  -text: String
  ///  -inputText: [String]
  ///  -urlString: [String]
  /// -Returns: NSMutableAttributedString
  func linkedText(text: String, inputText: [String], urlString: [String], font: UIFont) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(
      string: text,
      attributes: [NSAttributedString.Key.font: font])
    for i in 0..<urlString.count {
      let startValue: Int = text.distance(
        from: text.startIndex,
        to: text.range(of: inputText[i])?.lowerBound ?? String.Index(utf16Offset: 0, in: ""))
      let lenght: Int = text.distance(
        from: text.startIndex,
        to: text.range(of: inputText[i])?.upperBound ?? String.Index(utf16Offset: 0, in: ""))
      guard let link = URL(string: urlString[i]) else { return NSMutableAttributedString(string: "") }
      attributedString.setAttributes(
        [.link: link, .font: font],
        range: NSRange(
          location: startValue,
          length: (lenght - startValue)))
    }
    return attributedString
  }
}
