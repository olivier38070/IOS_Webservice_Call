import UIKit

class tableViewCell_def: UITableViewCell {
    
    //@IBOutlet var imageView: UIImageView
    @IBOutlet var label1:UILabel
    @IBOutlet var label2:UILabel
    
    
    /*
    init(frame: CGRect) {
    super.init(frame: frame)
    }
    
    init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    }
    */
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        println("Ente")
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }
}