import UIKit

protocol TabBarViewOutput: AnyObject {
  init(view: TabBarViewController)
  func tapMiddleButton(tabBarController: UITabBarController)
  func setViewcontrollers() -> [UIViewController]
}

class TabBarPresenter: TabBarViewOutput {
  weak var view: TabBarViewController?
  required init(view: TabBarViewController) {
    self.view = view
  }
  func tapMiddleButton(tabBarController: UITabBarController) {
    tabBarController.selectedIndex = 2
  }
  func setViewcontrollers() -> [UIViewController] {
    let charactersVC = CharactersTableViewController.createFromStoryboard
    charactersVC.tabBarItem.title = "characters"
    charactersVC.tabBarItem.image = UIImage(named: "charactersImage")

    let locationsVC = LocationTableViewController.createFromStoryboard
    locationsVC.tabBarItem.title = "locations"
    locationsVC.tabBarItem.image = UIImage(named: "locationsImage")
    locationsVC.tabBarItem.badgeColor = .white

    let favoritesVC = FavoritesViewController.createFromStoryboard
    favoritesVC.tabBarItem.title = ""

    let statisticsVC = StatisticsViewController.createFromStoryboard
    statisticsVC.tabBarItem.title = "statistics"
    statisticsVC.tabBarItem.image = UIImage(named: "statisticsImage")

    let episodesVC = EpisodesTableViewController.createFromStoryboard
    episodesVC.tabBarItem.title = "episodes"
    episodesVC.tabBarItem.image = UIImage(named: "episodesImage")

    let viewControllers = [charactersVC, locationsVC, favoritesVC, statisticsVC, episodesVC]
    return viewControllers
  }
}
