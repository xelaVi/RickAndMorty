import UIKit

extension UITableView {
  func middleHeaderConfiguration(text: String) -> UIView? {
    let headerView = UIView(frame: CGRect.zero)
    let infoLabel = UILabel(frame: CGRect(x: 16, y: 0, width: self.frame.width, height: 38))
    infoLabel.text = text
    infoLabel.textColor = .gray
    infoLabel.font = .systemFont(ofSize: 14)
    headerView.addSubview(infoLabel)
    return headerView
  }
}
