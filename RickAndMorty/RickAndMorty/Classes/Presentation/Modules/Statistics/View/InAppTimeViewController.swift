import UIKit

class InAppTimeViewController: UIViewController, StoryboardCreatable {
  @IBOutlet weak var hoursLabel: UILabel!
  @IBOutlet weak var minutesLabel: UILabel!
  @IBOutlet weak var secondsLabel: UILabel!
  private var presenter: InAppTimeViewOutput?
  private var currentDate = Int(Date().timeIntervalSince1970)
  private var startedTime = UserDefaults.standard.integer(forKey: UserDefaultsKeys.firstOpenTime.rawValue)
  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter = InAppTimePresenter(view: self)
    self.hoursLabel.text = presenter?.timerConfiguration(tag: "hours")
    self.minutesLabel.text = presenter?.timerConfiguration(tag: "minutes")
    self.secondsLabel.text = presenter?.timerConfiguration(tag: "seconds")
//    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//      let date = (self.currentDate - self.startedTime + SceneDelegate.timeInApp)
//      let hours = date / 3600 % 24
//      let minutes = date / 60 % 60
//      let seconds = date % 60
//      self.hoursLabel.text = self.configTime(time: hours)
//      self.minutesLabel.text = self.configTime(time: minutes)
//      self.secondsLabel.text = self.configTime(time: seconds)
//    }
  }
  @IBAction func resetTimeTap(_ sender: Any) {
    presenter?.resetTime()
//    SceneDelegate.timeInApp = 0
//    let firstOpenTime = Int(Date().timeIntervalSince1970)
//    UserDefaults.standard.set(firstOpenTime, forKey: UserDefaultsKeys.firstOpenTime.rawValue)
//    self.currentDate = firstOpenTime
//    self.startedTime = UserDefaults.standard.integer(forKey: UserDefaultsKeys.firstOpenTime.rawValue)
  }
//  private func configTime(time: Int) -> String {
//    let string: String
//    switch time {
//    case 0...9: string = "0" + String(time)
//    default: string = String(time)
//    }
//    return string
//  }
}
