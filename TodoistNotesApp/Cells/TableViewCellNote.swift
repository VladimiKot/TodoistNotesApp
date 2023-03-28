//  TodoListNotesApp
//  Created by Владимир on 18.03.2023.

import UIKit

class TableViewCellNote: UITableViewCell {

    @IBOutlet weak var imageChek: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var changeButtonTap: (() -> Void)?
    
    @IBAction func changeImageChek(_ sender: Any) {
        changeButtonTap?()
    }
    
    func updateNote(note: Note) {
        descLabel.text = note.title
        titleLabel.text = note.description
        
        if note.completed == true {
            imageChek.image = UIImage(named: "chek")
        } else {
            imageChek.image = UIImage(named: "noChek")
        }
        
    }
    
}
