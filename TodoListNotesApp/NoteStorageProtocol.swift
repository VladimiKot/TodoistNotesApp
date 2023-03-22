//
//  NoteStorageProtocol.swift
//  TodoListNotesApp
//
//  Created by Владимир on 21.03.2023.
//

import Foundation

protocol NoteStorageProtocol {
    
    
    func addNote(note: Note, completion: @escaping ((Note) -> Void))
    
    func removeNote(id: String, completion: @escaping (([Note]) -> Void))
    
    func getAllNotes(completion: @escaping (([Note]) -> Void))
    
    func getNote(id: String) -> Note?
    
}
