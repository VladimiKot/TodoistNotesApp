import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var imageChek: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var changeButtonTap: (() -> Void)?
    
    @IBAction func changeImageChek(_ sender: Any) {
        changeButtonTap?()
    }
    
    func cellConfigure(note: Note) {
        descLabel.text = note.title
        titleLabel.text = note.description
        
        if note.completed {
            imageChek.image = UIImage(named: "chek")
        } else {
            imageChek.image = UIImage(named: "noChek")
        }
    }
    
}
