import UIKit

extension UIView {
  func alertConfigure(tabBar: UITabBar) {
    guard let deleteAlert = Bundle(for: DeleteFavoritesAlert.self).loadNibNamed(
      "DeleteFavoritesAlert",
      owner: self,
      options: nil)?.first as? DeleteFavoritesAlert else { return }
    deleteAlert.alpha = 1
    deleteAlert.layer.cornerRadius = 8
    deleteAlert.clipsToBounds = true
    deleteAlert.translatesAutoresizingMaskIntoConstraints = false
    tabBar.addSubview(deleteAlert)

    NSLayoutConstraint.activate([
      deleteAlert.heightAnchor.constraint(equalToConstant: 52),
      deleteAlert.widthAnchor.constraint(equalToConstant: tabBar.bounds.width),
      deleteAlert.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
      deleteAlert.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -59)
    ])
    deleteAlert.isHidden = true
  }
}
