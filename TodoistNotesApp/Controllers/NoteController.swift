import Foundation
import UIKit

class NoteController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let router: Router = Router()
    let titleCellId = "NoteTitleTableViewCell"
    let descriptionCellId = "NoteDescriptionTableViewCell"
    let buttonCellId = "ButtonTableViewCell"
    var isEditScreenType: Bool = false
    var noteStorage: NoteStorageProtocol?
    var onClosed: (() -> Void)?
    var textTitle = ""
    var noteDescription = ""
    @IBOutlet weak var tableView: UITableView!
    
    public func configure(with title: String,
                          with description: String,
                          isEditType: Bool) {
        textTitle = title
        isEditScreenType = isEditType
        noteDescription = description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: titleCellId, bundle: nil),
                           forCellReuseIdentifier: titleCellId)
        tableView.register(UINib(nibName: descriptionCellId, bundle: nil),
                           forCellReuseIdentifier: descriptionCellId)
        tableView.register(UINib(nibName: buttonCellId, bundle: nil),
                           forCellReuseIdentifier: buttonCellId)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell: UITableViewCell
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: titleCellId, for: indexPath) as! NoteTitleTableViewCell
            if isEditScreenType {
                cell.updateTitle(with: textTitle)
            }
            cell.onTitleEdit = { [weak self] text in
                self?.textTitle = text
            }
            cell.selectionStyle = .none
            tableViewCell = cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellId, for: indexPath) as! NoteDescriptionTableViewCell
            if isEditScreenType {
                cell.updateDescription(with: noteDescription)
            }
            cell.onDescriptionEdit = { [weak self] text in
                self?.noteDescription = text
            }
            cell.selectionStyle = .none
            tableViewCell = cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: buttonCellId, for: indexPath) as! ButtonTableViewCell
            cell.onButtonTap = { [weak self] in
                guard let self = self else { return }
                let note: Note = Note(description: self.noteDescription,
                                      title: self.textTitle,
                                      id: "",
                                      completed: false)
                self.noteStorage?.addNote(note: note) {_ in
                    self.onClosed?()
                    self.router.closeNoteController(from: self)
                }
            }
            tableViewCell = cell
            
        default:
            return UITableViewCell()
        }
        return tableViewCell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEditScreenType {
            return 2
        } else {
            return 3
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 1:
            return 450
        default:
            return 50
        }
    }
}
