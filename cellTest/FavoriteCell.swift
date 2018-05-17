

import UIKit

class FavoriteCell: UITableViewCell
{
    @IBOutlet var fav_animal_id: UILabel!
    @IBOutlet var favalbum_file: UIImageView!
    @IBOutlet var favshelter_name: UILabel!
    @IBOutlet var favshelter_tel: UILabel!
    @IBOutlet var favanimal_foundplace: UILabel!
    @IBOutlet var favshelter_address: UILabel!
    @IBOutlet var favanimal_sex: UILabel!
    @IBOutlet var favanimal_age: UILabel!
    @IBOutlet var favanimal_bodytype: UILabel!
    @IBOutlet var favanimal_colour: UILabel!
    @IBOutlet var favanimal_sterilization: UILabel!
    @IBOutlet var favanimal_bacterin: UILabel!
    @IBOutlet var favanimal_remark: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
