//  TodoListNotesApp
//  Created by Владимир on 18.03.2023.

import UIKit

class TableViewCellButton: UITableViewCell {
    var onButtonTap: (() -> Void)?

    @IBAction func addItemCellButton(_ sender: Any) {
        onButtonTap?()
    }
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        button.frame.size.width = 5
        button.frame.size.height = 5
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 5)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 6
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
