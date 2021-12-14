import UIKit
import CoreData

class CharacterEpisodesCell: UITableViewCell, TableViewsCellInput {
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var desciption: UILabel!
  @IBOutlet weak var name: UILabel!
  var presenter: TableViewsCellOutput?

  override func awakeFromNib() {
    super.awakeFromNib()
    self.presenter = TableViewsCellPresenter(view: self)
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  @IBAction func favoriteButton(_ sender: UIButton) {
    presenter?.tapFavoriteButton(favoriteButton: favoriteButton)
  }
}
