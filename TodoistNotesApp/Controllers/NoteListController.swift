import Foundation
import UIKit

class NoteListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
     
    let idCell = "NoteTableViewCell"
    let router: Router = Router()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfNote: UILabel!
    private var allNotes: [Note] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchNotes: [Note] = []
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }

    private var isSearching: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var noteStorage: NoteStorageProtocol = NoteStorage()

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
    
    @IBAction func pushAddItem(_ sender: Any) {

        router.openNoteController(from: self, note: nil, noteStorage: noteStorage) { [weak self] in
            self?.noteStorage.getAllNotes(completion: { allNotes in
                self?.allNotes = allNotes
                self?.tableView.reloadData()
            })
        }
    }
    
   private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.secondarySystemBackground
        tableView.register(UINib(nibName: idCell, bundle: nil),
                           forCellReuseIdentifier: idCell)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfNotes = allNotes.count
        if isSearching {
            return searchNotes.count
        }
        
        if numberOfNotes == 0 {
            numberOfNote.isHidden = true
        } else if numberOfNotes == 1 {
            numberOfNote.isHidden = false
            numberOfNote.text = "\(numberOfNotes) note"
        } else {
            numberOfNote.isHidden = false
            numberOfNote.text = "\(numberOfNotes) notes"
        }
        
        return numberOfNotes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! NoteTableViewCell

        var currentNote: Note
        
        if isSearching {
            currentNote = searchNotes[indexPath.row]
        } else {
            currentNote = allNotes[indexPath.row]
        }

        noteCell.cellConfigure(note: currentNote)

        noteCell.changeButtonTap = {
            
            currentNote.completed.toggle()
            let updatedNotes = self.noteStorage.update(note: currentNote)
            self.allNotes = updatedNotes
            
            tableView.reloadData()
        }

        return noteCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentNote = allNotes[indexPath.row]
            noteStorage.removeNote(id: currentNote.id) { [weak self] allNotes in
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
        let note = allNotes[indexPath.row]
        router.openNoteController(from: self, note: note, noteStorage: noteStorage) {
        }
    }
}

extension NoteListController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
    }
    
    func filterContentFor(searchText: String) { 
        searchNotes = allNotes.filter({ (note: Note) in
            return note.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

