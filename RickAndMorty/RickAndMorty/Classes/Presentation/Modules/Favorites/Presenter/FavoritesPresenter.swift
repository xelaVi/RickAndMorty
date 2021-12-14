import Foundation
import UIKit
import CoreData

protocol FavoritesViewOutput: AnyObject {
  init(view: FavoritesViewInput)
  func changeSegmentStatus(tag: Int)
  func didSelectRowAt(indexPath: IndexPath)
  func cellForRowAt(status: Int, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
  func numberOfRowsInSection() -> Int
  func deleteAction(segmentIndex: Int, indexPath: IndexPath, tableView: UITableView) -> UISwipeActionsConfiguration
}

class FavoritesPresenter: FavoritesViewOutput {
  private weak var view: FavoritesViewInput?
  private var tag = 0
  required init(view: FavoritesViewInput) {
    self.view = view
  }

  func changeSegmentStatus(tag: Int) {
    self.tag = tag
  }

  func didSelectRowAt(indexPath: IndexPath) {
    switch tag {
    case 1:
      guard let presentVC = LocationCardTVC.createFromStoryboard as? LocationCardTVC else { return }
      presentVC.locationURL.append(LocalDataManager.favoriteLocation[indexPath.row].url ?? "")
      view?.showController(controller: presentVC)
    case 2:
      guard let presentVC = EpisodeCardTVC.createFromStoryboard as? EpisodeCardTVC else { return }
      presentVC.episodesURL.append(LocalDataManager.favoriteEpisodes[indexPath.row].url ?? "")
      view?.showController(controller: presentVC)
    default:
      guard let presentVC = CharacterCardTVC.createFromStoryboard as? CharacterCardTVC else { return }
      presentVC.characterURL.append(LocalDataManager.favoriteCharacters[indexPath.row].url ?? "")
      view?.showController(controller: presentVC)
    }
  }

  func numberOfRowsInSection() -> Int {
    switch tag {
    case 1: return LocalDataManager.favoriteLocation.count
    case 2: return LocalDataManager.favoriteEpisodes.count
    default: return LocalDataManager.favoriteCharacters.count
    }
  }

  func cellForRowAt(status: Int, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    switch status {
    case 1:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: "LocationFavCell",
        for: indexPath) as? LocationFavCell else {
          return UITableViewCell()
        }
      let data = LocalDataManager.favoriteLocation[indexPath.row]
      cellConfiguration(inputCell: cell, inputData: data, indexPath: indexPath)
      return cell
    case 2: guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "EpisodeFavCell",
      for: indexPath) as? EpisodeFavCell else {
        return UITableViewCell()
      }
      let data = LocalDataManager.favoriteEpisodes[indexPath.row]
      cellConfiguration(inputCell: cell, inputData: data, indexPath: indexPath)
      return cell
    default:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: "CharacterFavCell",
        for: indexPath) as? CharacterFavCell else {
          return UITableViewCell()
        }
      let data = LocalDataManager.favoriteCharacters[indexPath.row]
      cellConfiguration(inputCell: cell, inputData: data, indexPath: indexPath)
      return cell
    }
  }

  func cellConfiguration(inputCell: UITableViewCell, inputData: NSManagedObject, indexPath: IndexPath) {
    switch inputCell {
    case is CharacterFavCell:
      guard let cell = inputCell as? CharacterFavCell else { return }
      guard let data = inputData as? CharacterCache else { return }
      let imageURL = URL(string: data.image ?? "")

      cell.characterName.text = data.name
      cell.characterImage.kf.setImage(with: imageURL)
      statusConfig(cell: cell, status: data.status ?? "")

    case is LocationFavCell:
      guard let cell = inputCell as? LocationFavCell else { return }
      guard let data = inputData as? LocationCache else { return }
      cell.locationName.text = data.name
    case is EpisodeFavCell:
      guard let cell = inputCell as? EpisodeFavCell else { return }
      guard let data = inputData as? EpisodesCache else { return }
      cell.episodeName.text = data.name
      cell.episodeDetail.text = "Season " + episodesSubTitleFix(line: data.episodes ?? "", tag: "S")
      + ", " + "Episode " + episodesSubTitleFix(line: data.episodes ?? "", tag: "E")

    default:
      return
    }
  }

  private func statusConfig(cell: CharacterFavCell, status: String) {
    switch status {
    case "Alive":
      cell.characterStatus.textColor = .green
      cell.characterStatus.text = "\u{2022}" + status
    case "Dead":
      cell.characterStatus.textColor = .red
      cell.characterStatus.text = "\u{2022}" + status
    default:
      cell.characterStatus.text = ""
    }
  }

  private func episodesSubTitleFix(line: String, tag: String) -> String {
    guard let eRange = line.range(of: "E") else { return "" }
    guard let sEange = line.range(of: "S")?.upperBound else { return "" }
    switch tag {
    case "S": return String(line[sEange..<eRange.lowerBound])
    case "E": return String(line[eRange.upperBound...])
    default: return ""
    }
  }

  func deleteAction(segmentIndex: Int, indexPath: IndexPath, tableView: UITableView) -> UISwipeActionsConfiguration {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
      switch segmentIndex {
      case 1: LocalDataManager.favoriteLocation.remove(at: indexPath.row)
      case 2: LocalDataManager.favoriteEpisodes.remove(at: indexPath.row)
      default:
        LocalDataManager.favoriteCharacters.remove(at: indexPath.row)
      }
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return UISwipeActionsConfiguration() }
    let context = appDelegate.persistentContainer.viewContext

    switch segmentIndex {
    case 1: context.delete(LocalDataManager.favoriteLocation[indexPath.row])
    case 2: context.delete(LocalDataManager.favoriteEpisodes[indexPath.row])
    default:
      context.delete(LocalDataManager.favoriteCharacters[indexPath.row])
    }
    do {
      try context.save()
    } catch let error as NSError {
      print("Ошибка при удалении: \(error), \(error.userInfo)")
    }

    return swipeAction
  }
}
