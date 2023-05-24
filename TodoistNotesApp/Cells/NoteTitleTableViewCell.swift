import UIKit


class NoteTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteTitle: UITextView!
    var onTitleEdit: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

   private func configure() {
        noteTitle.delegate = self
        noteTitle.isEditable = true
        noteTitle.textContainer.lineFragmentPadding = 0
        noteTitle.textContainerInset = .zero
        noteTitle.font = UIFont.systemFont(ofSize: 17)
        noteTitle.textContainer.lineBreakMode = .byWordWrapping
        noteTitle.textContainerInset = UIEdgeInsets.zero
        noteTitle.isScrollEnabled = false
        noteTitle.becomeFirstResponder()
        
    }
    
    func updateTitle(with title: String) {
        noteTitle.text = title
    }
}

// MARK: - UITextFieldDelegate

extension NoteTitleTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let noteText = noteTitle.text, !noteText.isEmpty else { return }
        onTitleEdit?(noteText)
    }
}


