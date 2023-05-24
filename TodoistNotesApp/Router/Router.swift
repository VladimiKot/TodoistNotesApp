import Foundation
import UIKit

class Router {
        
    func openNoteController(from vc: UIViewController,
                            note: Note?, noteStorage: NoteStorageProtocol,
                            completion: @escaping () -> Void) {
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil) 
        let noteController = storyBoard.instantiateViewController(withIdentifier: "NoteController") as! NoteController
        guard let note = note else {
            noteController.noteStorage = noteStorage
            noteController.onClosed = completion
            vc.navigationController?.pushViewController(noteController, animated: true)
            return
        }
        noteController.configure(with: note.title, with: note.description, isEditType: true)
        vc.navigationController?.pushViewController(noteController, animated: true)
    }
    
    func closeNoteController(from vc: UIViewController) {
        vc.navigationController?.popViewController(animated: true)
    }
}
