import UIKit

class EpisodeFavCell: UITableViewCell {
  @IBOutlet weak var episodeName: UILabel!
  @IBOutlet weak var episodeDetail: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
