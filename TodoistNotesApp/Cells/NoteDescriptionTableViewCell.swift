//  TodoListNotesApp
//  Created by Владимир on 18.03.2023.

import UIKit

class NoteDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteDescription: UITextView!
    var onDescriptionEdit: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func conifgure() {
        noteDescription.delegate = self
        noteDescription.isEditable = true
        noteDescription.textContainer.lineFragmentPadding = 0
        noteDescription.textContainerInset = .zero
        noteDescription.font = UIFont.systemFont(ofSize: 17)
        noteDescription.textContainer.lineBreakMode = .byWordWrapping
        noteDescription.textContainerInset = UIEdgeInsets.zero
        noteDescription.isScrollEnabled = false
    }
    
    func updateDescription(with description: String) {
        noteDescription.text = description
    }
}
// MARK: - UITextFieldDelegate
extension NoteDescriptionTableViewCell: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let noteDescription = noteDescription.text,
              !noteDescription.isEmpty else { return }
        onDescriptionEdit?(noteDescription)
    }
}
