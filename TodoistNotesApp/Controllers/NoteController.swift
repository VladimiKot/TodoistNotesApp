//  TodoListNotesApp
//
//  Created by Владимир on 18.03.2023.

import Foundation
import UIKit

class NoteController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let router: Router = Router()
    var isEditScreenType: Bool = false
    @IBOutlet weak var tableView: UITableView!
    var noteStorage: NoteStorageProtocol?
    let idCellTitle = "NoteTitleTableViewCell"
    let idCellDescription = "NoteDescriptionTableViewCell"
    let idCellButton = "ButtonTableViewCell"
    var onClosed: (() -> Void)?
    var textTitle = ""
    var noteDescription = ""
    var id = ""
    
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
        tableView.register(UINib(nibName: idCellTitle, bundle: nil),
                           forCellReuseIdentifier: idCellTitle)
        tableView.register(UINib(nibName: idCellDescription, bundle: nil),
                           forCellReuseIdentifier: idCellDescription)
        tableView.register(UINib(nibName: idCellButton, bundle: nil),
                           forCellReuseIdentifier: idCellButton)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell: UITableViewCell
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: idCellTitle, for: indexPath) as! NoteTitleTableViewCell
            if isEditScreenType {
                cell.updateTitle(with: textTitle)
            }
            cell.configure()
            cell.onTitleEdit = { [weak self] text in
                self?.textTitle = text
            }
            cell.selectionStyle = .none
            tableViewCell = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: idCellDescription, for: indexPath) as! NoteDescriptionTableViewCell
            if isEditScreenType {
                cell.updateDescription(with: noteDescription)
            }
            cell.conifgure()
            cell.onDescriptionEdit = { [weak self] text in
                self?.noteDescription = text
            }
            cell.selectionStyle = .none
            tableViewCell = cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: idCellButton, for: indexPath) as! ButtonTableViewCell
            cell.onButtonTap = {
                let note: Note = Note(description: self.noteDescription,
                                      title: self.textTitle,
                                      id: self.id,
                                      completed: false)
                self.noteStorage?.addNote(note: note) { [weak self] _ in
                    self?.onClosed?()
                    guard ((self?.router.closeController(controller: self!)) != nil) else {return}
                }
            }
            tableViewCell = cell
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
        if indexPath.row == 0 {
            return 50
        } else if indexPath.row == 1 {
            return 550
        } else {
            return 50
        }
    }
}





