import Foundation

protocol InAppTimeViewOutput: AnyObject {
  func timerConfiguration(tag: String) -> String
  func resetTime()
}
class InAppTimePresenter: InAppTimeViewOutput {
  private var currentDate = Int(Date().timeIntervalSince1970)
  private var startedTime = UserDefaults.standard.integer(forKey: UserDefaultsKeys.firstOpenTime.rawValue)
  private weak var view: InAppTimeViewController?

  init(view: InAppTimeViewController) {
    self.view = view
  }
  func timerConfiguration(tag: String) -> String {
    let date = (self.currentDate - self.startedTime + SceneDelegate.timeInApp)
    let hours = date / 3600 % 24
    let minutes = date / 60 % 60
    let seconds = date % 60

    switch tag {
    case "hours":
      return self.configTime(time: hours)
    case "minutes":
      return self.configTime(time: minutes)
    default:
      return self.configTime(time: seconds)
    }
    view?.reloadInputViews()
  }
  private func configTime(time: Int) -> String {
    let string: String
    switch time {
    case 0...9: string = "0" + String(time)
    default: string = String(time)
    }
    return string
  }
  func resetTime() {
    SceneDelegate.timeInApp = 0
    let firstOpenTime = Int(Date().timeIntervalSince1970)
    UserDefaults.standard.set(firstOpenTime, forKey: UserDefaultsKeys.firstOpenTime.rawValue)
    self.currentDate = firstOpenTime
    self.startedTime = UserDefaults.standard.integer(forKey: UserDefaultsKeys.firstOpenTime.rawValue)
  }
}
