import UIKit
import Kingfisher
import CoreData

protocol LocationCardOutput: AnyObject {
  init(view: LocationCardInput, locationURL: [String])
  func headerHeight(section: Int) -> CGFloat
  func heightForRows(indexPath: IndexPath) -> CGFloat
  func didSelectRow(indexPath: IndexPath)
  func cellView(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
  func requestForCard(tableView: UITableView)
  func numberOfRows(section: Int) -> Int
  func sharedConfigure()
  func topHeaderLocation(tableView: UITableView, favoriteButton: UIButton) -> UIView
  func tapFavoriteButton(favoriteButton: UIButton)
}

class LocationCardPresenter: LocationCardOutput {
  private weak var view: LocationCardInput?
  private weak var singleRequestDelegate: SingleRequestProtocol?
  private weak var deleteFromCache: LocalCacheDeleteProtocol?
  private weak var saveInCacheProtocol: LocalCacheSaveProtocol?

  private var locationRequestResult: [LocationResultsDTO]?
  private var characterRequestResult: [CharacterResultsDTO]?

  private var clickedTopButton = false
  private var cardArray: [String]?
  private var locationURL: [String] = []
  private var deleteObject: LocationCache?

  required init(view: LocationCardInput, locationURL: [String]) {
    self.view = view
    self.locationURL = locationURL
    self.saveInCacheProtocol = LocalDataManager.shared
    self.deleteFromCache = LocalDataManager.shared
    self.singleRequestDelegate = RequestServiceAPI.shared
  }
  func headerHeight(section: Int) -> CGFloat {
    switch section {
    case 0:
      return 124
    default:
      return 38
    }
  }
  func heightForRows(indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 44
    default:
      return 60
    }
  }
  func didSelectRow(indexPath: IndexPath) {
    switch indexPath.section {
    case 1:
      guard let characterCard = CharacterCardTVC.createFromStoryboard as? CharacterCardTVC
      else { return }
      characterCard.characterURL.append(self.characterRequestResult?[indexPath.row].url ?? "")
      view?.segueCell(card: characterCard)
    default: return
    }
  }
  func cellView(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cellInfo = tableView.dequeueReusableCell(
        withIdentifier: "LocationInfoCell",
        for: indexPath) as? LocationInfoCell else { return UITableViewCell() }
      cellInfo.detailLabel.text = cardArray?[indexPath.row]
      cellInfo.titleLabel.text = setTitles()[indexPath.row]
      if cellInfo.detailLabel.text?.isEmpty == true {
        cellInfo.detailLabel?.text = "unknown"
      }
      return cellInfo
    default:
      guard let cellCharacter = tableView.dequeueReusableCell(
        withIdentifier: "LocationCharacterCell",
        for: indexPath) as? LocationCharacterCell else { return UITableViewCell() }
      let data = characterRequestResult?[indexPath.row]
      let imageURL = URL(string: data?.image ?? "")
      if LocalDataManager.favoriteCharacters.contains(where: { $0.id == (data?.id ?? 0) }) {
        cellCharacter.favoriteButton.setImage(ImagesCell.favoriteSelected, for: .normal)
        cellCharacter.favoriteButton.tintColor = CustomColors.mainColor
        let deleteObject = LocalDataManager.favoriteCharacters.first { $0.id == (data?.id ?? 0) }
        cellCharacter.presenter?.cellDeleteObject(deleteObject: deleteObject ?? LocationCache())
        cellCharacter.presenter?.cellClicked(clicked: true)
      } else {
        cellCharacter.favoriteButton.setImage(ImagesCell.favorite, for: .normal)
        cellCharacter.favoriteButton.tintColor = CustomColors.border
        cellCharacter.presenter?.cellClicked(clicked: false)
      }
      cellCharacter.characterName.text = data?.name
      cellCharacter.presenter?.statusCase(
        status: data?.status ?? "",
        characterStatus: cellCharacter.characterStatus,
        favoriteButton: cellCharacter.favoriteButton)
      cellCharacter.presenter?.cellDataRequest(dataCellRequest: data)
      cellCharacter.characterImage.kf.setImage(with: imageURL)

      return cellCharacter
  }
}
  func requestForCard(tableView: UITableView) {
    DispatchQueue.global(qos: .default).sync {
      self.singleRequestDelegate?.requestForLocation(urlArray: self.locationURL) { [weak self] responce in
        self?.locationRequestResult = responce
        self?.cardArray = [
          responce[0].type ,
          responce[0].dimension ,
          "".dateFormatterConfiguration(data: responce[0].created)
        ]

        self?.requestCharacters(urlArray: responce[0].residents)
        sleep(1)
        DispatchQueue.main.async {
          tableView.reloadData()
        }
      }
    }
  }
  private func requestCharacters(urlArray: [String]) {
    self.singleRequestDelegate?.requestForCharacter(urlArray: urlArray) { [weak self] responce in
      self?.characterRequestResult = responce
    }
  }
  private func setTitles() -> [String] {
    let titles = ["Type", "Dimension", "Date"]
    return titles
  }

  func numberOfRows(section: Int) -> Int {
    switch section {
    case 0:
      return cardArray?.count ?? 0
    default:
      return locationRequestResult?[0].residents.count ?? 0
    }
  }

  func sharedConfigure() {
    let returnValue = [characterRequestResult?[0].name, characterRequestResult?[0].image]
    let shared = UIActivityViewController(activityItems: returnValue as [Any], applicationActivities: nil)
    view?.showShared(sharedController: shared)
  }

  func topHeaderLocation(tableView: UITableView, favoriteButton: UIButton) -> UIView {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 124))
    let infoLabel = UILabel(frame: CGRect(x: 16, y: 24, width: 343, height: 48))
    infoLabel.numberOfLines = 2
    infoLabel.text = locationRequestResult?[0].name
    infoLabel.font = .systemFont(ofSize: 24)
    infoLabel.textColor = .black

    favoriteButton.frame = CGRect(x: 18, y: 84, width: 160, height: 23)
    if LocalDataManager.favoriteLocation.contains(where: { $0.id == (locationRequestResult?[0].id ?? 0) }) {
      favoriteButton.setImage(ImagesCell.favoriteSelected, for: .normal)
      favoriteButton.tintColor = CustomColors.mainColor
      self.deleteObject = LocalDataManager.favoriteLocation.first { $0.id == (locationRequestResult?[0].id ?? 0) }
      self.clickedTopButton = true
    } else {
      favoriteButton.setImage(ImagesCell.favorite, for: .normal)
      favoriteButton.tintColor = .darkGray
      self.clickedTopButton = false
    }
    favoriteButton.setTitle(" Add to Favorites", for: .normal)
    favoriteButton.setTitleColor(.black, for: .normal)

    headerView.addSubview(favoriteButton)
    headerView.addSubview(infoLabel)
    return headerView
  }

  func tapFavoriteButton(favoriteButton: UIButton) {
    if clickedTopButton {
      deleteFromCache?.deleteItem(deleteData: deleteObject ?? NSManagedObject())
      favoriteButton.setImage(ImagesCell.favorite, for: .normal)
      favoriteButton.tintColor = CustomColors.border
    } else {
      guard let saveData = locationRequestResult else { return }
      saveInCacheProtocol?.saveData(data: saveData[0])
      favoriteButton.setImage(
        ImagesCell.favoriteSelected,
        for: .normal)
      favoriteButton.tintColor = CustomColors.mainColor
    }
    clickedTopButton.toggle()
  }
}
