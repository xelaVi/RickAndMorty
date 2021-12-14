import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  static var timeInApp: Int = 0

  private let firstOpenTime = Int(Date().timeIntervalSince1970)
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    self.window?.windowScene = windowScene
    if UserDefaults.standard.bool(forKey: UserDefaultsKeys.notfirstStart.rawValue) {
      self.window?.rootViewController = LoginViewController.createFromStoryboard
    } else {
      UserDefaults.standard.set(true, forKey: UserDefaultsKeys.notfirstStart.rawValue)
      self.window?.rootViewController = PreviewViewController.createFromStoryboard
    }
    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      SceneDelegate.timeInApp += 1
    }
  }
  func sceneWillResignActive(_ scene: UIScene) {
    NotificationCenter.shared.sendNotifications(interval: 5)
    let userDefaultDate = UserDefaults.standard.integer(forKey: UserDefaultsKeys.firstOpenTime.rawValue)
    let saveDate = userDefaultDate + SceneDelegate.timeInApp
    UserDefaults.standard.set(saveDate, forKey: UserDefaultsKeys.firstOpenTime.rawValue)
  }
  func sceneWillEnterForeground(_ scene: UIScene) {
    UIApplication.shared.applicationIconBadgeNumber = 0
  }
}
