import UIKit

class CharacterFavCell: UITableViewCell {
  @IBOutlet weak var characterImage: UIImageView!
  @IBOutlet weak var characterName: UILabel!
  @IBOutlet weak var characterStatus: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    characterImage.layer.cornerRadius = 23.5
    characterImage.clipsToBounds = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
