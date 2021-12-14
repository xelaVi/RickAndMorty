import UIKit

class StatisticsViewController: UIViewController, StoryboardCreatable {
  @IBOutlet weak var outView: UIView!
  @IBOutlet weak var segmentControl: UISegmentedControl!
  private let appearance = UINavigationBarAppearance()
  override func viewDidLoad() {
    super.viewDidLoad()
    configurationNavgiation(title: "Statistics")
    outView.addSubview(InAppTimeViewController.createFromStoryboard.view)
  }
  @IBAction func segmentAction(_ sender: Any) {
    switch segmentControl.selectedSegmentIndex {
    case 1:
      let mapVC = GoogleMapViewController.createFromStoryboard
      outView.subviews.first?.removeFromSuperview()
      outView.addSubview(mapVC.view)
    default:
      let timerVC = InAppTimeViewController.createFromStoryboard
      outView.subviews.first?.removeFromSuperview()
      outView.addSubview(timerVC.view)
  }
  }
}
