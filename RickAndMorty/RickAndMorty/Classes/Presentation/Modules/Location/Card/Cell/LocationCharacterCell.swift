import UIKit
import CoreData

class LocationCharacterCell: UITableViewCell, TableViewsCellInput {
  @IBOutlet weak var characterImage: UIImageView!
  @IBOutlet weak var characterName: UILabel!
  @IBOutlet weak var characterStatus: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  var presenter: TableViewsCellOutput?

  override func awakeFromNib() {
    super.awakeFromNib()
    self.presenter = TableViewsCellPresenter(view: self)
    characterImage.layer.cornerRadius = 23.5
    characterImage.clipsToBounds = true
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  @IBAction func favoriteButton(_ sender: UIButton) {
    presenter?.tapFavoriteButton(favoriteButton: favoriteButton)
  }
}
