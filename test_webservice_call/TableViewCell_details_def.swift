import UIKit

class tableViewCell_details_def: UITableViewCell {
    
    @IBOutlet var label1:UILabel
    @IBOutlet var label2:UILabel
    @IBOutlet var label3:UILabel
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        println("init details cell")
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }
}