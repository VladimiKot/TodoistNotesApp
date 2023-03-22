//  TodoListNotesApp
//  Created by Владимир on 18.03.2023.

import Foundation
import UIKit

class NoteListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let idCell = "TableViewCellFirst"
    let router: Router = Router()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countAllNotes: UILabel!
    private var allNotes: [Note] = []
    private let apiClient: APIClient = APIClient()
    private let searchController = UISearchController(searchResultsController: nil)
    private var filtredDataNotes: [Note] = []
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var noteStorage: NoteStorage = NoteStorage()
    private let noteController: NoteController = NoteController()
    
    
    @IBAction func pushAddItem(_ sender: Any) {
        
        router.openController(controller: self, noteStorage: noteStorage) { [weak self] in
            self?.noteStorage.getAllNotes(completion: { allNotes in
                self?.allNotes = allNotes
                self?.tableView.reloadData()
            })
        }
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.secondarySystemBackground
        tableView.register(UINib(nibName: idCell, bundle: nil),
                           forCellReuseIdentifier: idCell)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupView()
        setupSearchController()
        noteStorage.getAllNotes { [weak self] allNotes in
            self?.allNotes = allNotes
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countNotes = allNotes.count
        if isFiltering {
            return filtredDataNotes.count

        }
        if countNotes == 0 {
            countAllNotes.isHidden = true
        } else if countNotes == 1 {
            countAllNotes.isHidden = false
            countAllNotes.text = "\(countNotes) note"
        } else {
            countAllNotes.isHidden = false
            countAllNotes.text = "\(countNotes) notes"
        }
        
        return countNotes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! TableViewCellFirst
        var currentItem: Note
        
        if isFiltering {
            currentItem = filtredDataNotes[indexPath.row]
        } else {
            currentItem = allNotes[indexPath.row]
        }
        cell.descLabel?.text = currentItem.title
        cell.titleLabel?.text = currentItem.description
        
        cell.changeButtonTap = {
            if self.noteStorage.getNote(id: currentItem.id)?.completed == true
            {
                let cellImage = tableView.cellForRow(at: indexPath) as! TableViewCellFirst
                currentItem.completed = true
                cellImage.imageChek.image = UIImage(named: "chek")
                
            } else {
                let cellImage = tableView.cellForRow(at: indexPath) as! TableViewCellFirst
                currentItem.completed = false
                cellImage.imageChek.image = UIImage(named: "noChek")
                
            }
        }
        
        if tableView.isEditing {
            cell.descLabel?.alpha = 0.4
            cell.imageChek?.alpha = 0.4
        } else {
            cell.descLabel?.alpha = 1
            cell.imageChek?.alpha = 1
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentItem = allNotes[indexPath.row]
            noteStorage.removeNote(id: currentItem.id) { [weak self] allNotes in
                self?.allNotes = allNotes
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
            allNotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let noteController = storyboard?.instantiateViewController(withIdentifier: "NoteController") as! NoteController
        let getNote = allNotes[indexPath.row]
        noteController.configure(with: getNote.title, with: getNote.description, isEditType: true)
        navigationController?.pushViewController(noteController, animated: true)
    }
    
}

extension NoteListController: UISearchResultsUpdating {
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
    }
    
    func filterContentFor(searchText: String) {
        filtredDataNotes = allNotes.filter({ (note: Note) in
            return note.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

