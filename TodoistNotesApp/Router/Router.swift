//
//  Router.swift
//  TodoListNotesApp
//
//  Created by Владимир on 21.03.2023.
//

import Foundation
import UIKit

class Router {
    
    func openController(controller: UIViewController, noteStorage: NoteStorage, completion: @escaping () -> Void) {
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let noteController = storyBoard.instantiateViewController(withIdentifier: "NoteController") as! NoteController
        
        noteController.noteStorage = noteStorage
        noteController.onClosed = completion
        
        controller.navigationController?.pushViewController(noteController, animated: true)
        
    }
    
    func closeController(controller: UIViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
}
