import UIKit

protocol LocationCardInput: AnyObject {
  func showShared(sharedController: UIActivityViewController)
  func segueCell(card: CharacterCardTVC)
}

class LocationCardTVC: UITableViewController, StoryboardCreatable {
  private var presenter: LocationCardOutput?
  var locationURL: [String] = []
  private let favoriteButton = UIButton()

  private var imageCharacters: [UIImage] = []

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.presenter = LocationCardPresenter(view: self, locationURL: self.locationURL)
    presenter?.requestForCard(tableView: self.tableView)
    favoriteButton.addTarget(self, action: #selector(favoriteButtonTap(_:)), for: .touchUpInside)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.backgroundColor = .systemGray6
    self.navigationItem.title = "Location Card"
    self.shareButtonConfig()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter?.numberOfRows(section: section) ?? 0
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return presenter?.headerHeight(section: section) ?? 0
  }

  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 1
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return presenter?.heightForRows(indexPath: indexPath) ?? 0
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter?.didSelectRow(indexPath: indexPath)
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return presenter?.cellView(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 0:
      return topHeaderConfiguration()
    default:
      return tableView.middleHeaderConfiguration(text: "CHARACTERS IN LOCATION")
    }
  }

  private func topHeaderConfiguration () -> UIView? {
    return presenter?.topHeaderLocation(tableView: self.tableView, favoriteButton: favoriteButton)
  }

  private func shareButtonConfig() {
    let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(activityAction))
    self.navigationItem.rightBarButtonItem = actionButton
  }

  @objc private func activityAction() {
    presenter?.sharedConfigure()
  }

  @objc func favoriteButtonTap(_ sender: UIButton) {
    presenter?.tapFavoriteButton(favoriteButton: sender)
  }
}
extension LocationCardTVC: LocationCardInput {
  func showShared(sharedController: UIActivityViewController) {
    present(sharedController, animated: true)
  }

  func segueCell(card: CharacterCardTVC) {
    show(card, sender: nil)
  }
}
