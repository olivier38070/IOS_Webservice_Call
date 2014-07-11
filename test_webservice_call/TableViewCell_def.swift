import UIKit

class tableViewCell_def: UITableViewCell {

    @IBOutlet var label1:UILabel
    @IBOutlet var label2:UILabel
    @IBOutlet var label3:UILabel
    @IBOutlet var label4:UILabel
    
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        println("init cell")
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }
}