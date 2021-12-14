import UIKit
import Kingfisher
import CoreData

class EpisodeCardTVC: UITableViewController, StoryboardCreatable {
  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()

  private weak var deleteFromCache: LocalCacheDeleteProtocol?
  private weak var saveInCacheProtocol: LocalCacheSaveProtocol?
  private weak var serviceRequest: SingleRequestProtocol?

  var episodesURL: [String] = []
  private var deletObject: EpisodesCache?
  private var episodesRequestResult: [EpisodesResultsDTO]?
  private var charactersDTO: CharactersDTO?
  private var titles: [String]?
  private var headerView: UIView?
  private var infoLabel: UILabel?
  private var characterRequestResult: [CharacterResultsDTO]?
  private var cardArray: [String]?
  private var clickedTopButton = false
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.saveInCacheProtocol = LocalDataManager.shared
    self.deleteFromCache = LocalDataManager.shared
    self.serviceRequest = RequestServiceAPI.shared
    self.episodesRequest(urlArray: episodesURL)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.backgroundColor = .systemGray6
    self.navigationItem.title = "Episode Card"
    self.shareButtonConfig()
    self.titles = [ "Date", "Code" ]
  }

  private func episodesRequest(urlArray: [String]) {
    DispatchQueue.global(qos: .default).sync {
      self.serviceRequest?.requestForEpisodes(urlArray: urlArray) { [weak self] responce in
        self?.episodesRequestResult = responce
        self?.cardArray = [
          String(self?.dateFormatterConfiguration(data: responce[0].created) ?? ""),
          responce[0].episode
        ]
        self?.requestCharacters(urlArray: responce[0].characters)
        sleep(1)
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
      }
    }
  }

  private func requestCharacters(urlArray: [String]) {
    self.serviceRequest?.requestForCharacter(urlArray: urlArray) { [weak self] responce in
      self?.characterRequestResult = responce
    }
  }

  private func dateFormatterConfiguration(data: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    guard let date = dateFormatter.date(from: data) else { return "" }
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter.string(from: date)
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return cardArray?.count ?? 0
    default:
      return episodesRequestResult?[0].characters.count ?? 0
    }
  }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 124
    default:
      return 38
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 44
    default:
      return 60
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 1:
      guard let presentVC = CharacterCardTVC.createFromStoryboard as? CharacterCardTVC
      else { return }
      presentVC.characterURL.append(self.characterRequestResult?[indexPath.row].url ?? "")
      show(presentVC, sender: nil)
    default: return
    }
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cellInfo = tableView.dequeueReusableCell(
        withIdentifier: "EpisodeInfoCell",
        for: indexPath) as? EpisodeInfoCell else { return UITableViewCell() }
      cellInfo.detailLabel.text = cardArray?[indexPath.row]
      cellInfo.titleLabel.text = titles?[indexPath.row]
      if cellInfo.detailLabel.text?.isEmpty == true {
        cellInfo.detailLabel?.text = "unknown"
      }
      return cellInfo
    default:
      guard let cellCharacter = tableView.dequeueReusableCell(
        withIdentifier: "EpisodeCharactersCell",
        for: indexPath) as? EpisodeCharactersCell else { return UITableViewCell() }
      let data = characterRequestResult?[indexPath.row]
      let imageURL = URL(string: data?.image ?? "")
      if LocalDataManager.favoriteCharacters.contains(where: { $0.id == (data?.id ?? 0) }) {
        cellCharacter.favoriteButton.setImage(UIImage(named: "favoriteSelected"), for: .normal)
        cellCharacter.favoriteButton.tintColor = UIColor(named: "mainColor")
        let deleteObject = LocalDataManager.favoriteCharacters.first { $0.id == (data?.id ?? 0) }
        cellCharacter.presenter?.cellDeleteObject(deleteObject: deleteObject ?? CharacterCache())
        cellCharacter.presenter?.cellClicked(clicked: true)
      } else {
        cellCharacter.favoriteButton.setImage(UIImage(named: "favouriteImage"), for: .normal)
        cellCharacter.favoriteButton.tintColor = .darkGray
        cellCharacter.presenter?.cellClicked(clicked: false)
      }
      cellCharacter.characterName.text = data?.name
      switch data?.status {
      case "Alive":
        cellCharacter.characterStatus.textColor = .green
        cellCharacter.characterStatus.text = "\u{2022}" + (data?.status ?? "")
        cellCharacter.favoriteButton.isHidden = false
      case "Dead":
        cellCharacter.characterStatus.textColor = .red
        cellCharacter.characterStatus.text = "\u{2022}" + (data?.status ?? "")
        cellCharacter.favoriteButton.isHidden = true
      default:
        cellCharacter.characterStatus.text = ""
      }
      cellCharacter.presenter?.cellDataRequest(dataCellRequest: data)
      cellCharacter.characterImage.kf.setImage(with: imageURL)

      return cellCharacter
    }
  }
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 0:
      return topHeaderConfiguration()
    default:
      return middleHeaderConfiguration(text: "CHARACTERS IN EPISODE")
    }
  }
  private func topHeaderConfiguration () -> UIView? {
    headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 124))
    infoLabel = UILabel(frame: CGRect(x: 16, y: 24, width: 343, height: 48))
    infoLabel?.numberOfLines = 2
    infoLabel?.text = episodesRequestResult?[0].name
    infoLabel?.font = .systemFont(ofSize: 24)
    infoLabel?.textColor = .black
    let favoriteButton = UIButton(frame: CGRect(x: 16, y: 88, width: 160, height: 24))
    if LocalDataManager.favoriteEpisodes.contains(where: { $0.id == (episodesRequestResult?[0].id ?? 0) }) {
      favoriteButton.setImage(UIImage(named: "favoriteSelected"), for: .normal)
      favoriteButton.tintColor = UIColor(named: "mainColor")
      self.deletObject = LocalDataManager.favoriteEpisodes.first { $0.id == (episodesRequestResult?[0].id ?? 0) }
      self.clickedTopButton = true
    } else {
      favoriteButton.setImage(UIImage(named: "favouriteImage"), for: .normal)
      favoriteButton.tintColor = .darkGray
      self.clickedTopButton = false
    }
    favoriteButton.setTitle(" Add to Favorites", for: .normal)
    favoriteButton.setTitleColor(.black, for: .normal)
    favoriteButton.addTarget(self, action: #selector(favoriteButtonTap(_:)), for: .touchUpInside)
    headerView?.addSubview(favoriteButton)
    headerView?.addSubview(infoLabel ?? UILabel())
    return headerView
  }
  private func middleHeaderConfiguration(text: String) -> UIView? {
    headerView = UIView(frame: CGRect.zero)
    infoLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width, height: 38))
    infoLabel?.text = text
    infoLabel?.textColor = .gray
    infoLabel?.font = .systemFont(ofSize: 14)
    headerView?.addSubview(infoLabel ?? UILabel())
    return headerView
  }

  private func shareButtonConfig() {
    let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(activityAction))
    self.navigationItem.rightBarButtonItem = actionButton
  }

  @objc private func activityAction() {
    let returnValue = [characterRequestResult?[0].name, characterRequestResult?[0].image]
    let shareController = UIActivityViewController(activityItems: returnValue as [Any], applicationActivities: nil)
    present(shareController, animated: true)
  }

  @objc func favoriteButtonTap(_ sender: UIButton) {
    if clickedTopButton {
      deleteFromCache?.deleteItem(deleteData: deletObject ?? NSManagedObject())
      sender.setImage(UIImage(named: "favouriteImage"), for: .normal)
      sender.tintColor = .black
    } else {
      guard let saveData = episodesRequestResult else { return }
      saveInCacheProtocol?.saveData(data: saveData[0])
      sender.setImage(
        UIImage(named: "favoriteSelected"),
        for: .normal)
      sender.tintColor = UIColor(named: "mainColor")
    }
    clickedTopButton.toggle()
  }
}
