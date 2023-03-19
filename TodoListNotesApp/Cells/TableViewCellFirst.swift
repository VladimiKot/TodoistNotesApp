//  TodoListNotesApp
//  Created by Владимир on 18.03.2023.

import UIKit

class TableViewCellFirst: UITableViewCell {

    @IBOutlet weak var imageChek: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var changeButtonTap: (() -> Void)?
    
    @IBAction func changeImageChek(_ sender: Any) {
        changeButtonTap?()


    }
    
}
