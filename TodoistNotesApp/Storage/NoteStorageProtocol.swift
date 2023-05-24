import Foundation

protocol NoteStorageProtocol {
    
    func addNote(note: Note, completion: @escaping ((Note) -> Void))
    
    func removeNote(id: String, completion: @escaping (([Note]) -> Void))
    
    func getAllNotes(completion: @escaping (([Note]) -> Void))
    
    func update(note: Note) -> [Note]
    
}
