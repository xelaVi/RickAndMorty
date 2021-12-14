import UIKit

enum ImagesCell {
  static var favorite: UIImage { return UIImage(named: "favouriteImage") ?? UIImage() }
  static var favoriteSelected: UIImage { return UIImage(named: "favoriteSelected") ?? UIImage() }
  static var segue: UIImage { return UIImage(named: "infoImage") ?? UIImage() }
}
enum ImagesPageView {
  static var emptyDot: UIImage { return UIImage(named: "emptyDot") ?? UIImage() }
  static var fullDot: UIImage { return UIImage(named: "fullDot") ?? UIImage() }
}
enum ImagesTabBar {
  static var characters: UIImage { return UIImage(named: "charactersImage") ?? UIImage() }
  static var episodes: UIImage { return UIImage(named: "episodesImage") ?? UIImage() }
  static var favorites: UIImage { return UIImage(named: "favButtonImage") ?? UIImage() }
  static var locations: UIImage { return UIImage(named: "locationsImage") ?? UIImage() }
  static var statistics: UIImage { return UIImage(named: "statisticsImage") ?? UIImage() }
}
enum ImagesLogin {
  static var eye: UIImage { return UIImage(named: "visibleEye") ?? UIImage() }
}
