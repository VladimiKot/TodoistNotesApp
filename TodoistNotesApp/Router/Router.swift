//
//  Router.swift
//  TodoListNotesApp
//
//  Created by Владимир on 21.03.2023.
//

import Foundation
import UIKit

class Router {
    
    func openNoteController(from vc: UIViewController, noteStorage: NoteStorage, completion: @escaping () -> Void) {
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let noteController = storyBoard.instantiateViewController(withIdentifier: "NoteController") as! NoteController
        
        noteController.noteStorage = noteStorage
        noteController.onClosed = completion
        
        vc.navigationController?.pushViewController(noteController, animated: true)
        
    }
    
    func closeNoteController(from vc: UIViewController) {
        vc.navigationController?.popViewController(animated: true)
    }
}
