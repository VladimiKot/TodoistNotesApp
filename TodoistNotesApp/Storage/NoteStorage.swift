//  TodoListNotesApp
//  Created by Владимир on 18.03.2023.


import Foundation

class NoteStorage {
    
    private var notes: [Note] = []
    let apiClient: APIClient = APIClient()
    let defaults = UserDefaults.standard
    
    var dictonaryNotes: [String: Bool] {
        set {
            defaults.set(newValue, forKey: "dictionaryNotes")
        }
        get {
            let retrieveDictionaryNotes = defaults.object(forKey: "dictionaryNotes") as? [String: Bool] ?? [String: Bool]()
            return retrieveDictionaryNotes
        }
    }
}

// MARK: NoteStorageProtocol

extension NoteStorage : NoteStorageProtocol {
    
    func update(note: Note) -> [Note] {
        
        let notesArray = notes.map { storedNote -> Note in
            if note.id == storedNote.id {
                return note
            }
            return storedNote
        }
        self.dictonaryNotes.updateValue(note.completed, forKey: note.id)
        notes = notesArray
        
        return notes
    }
    
    func addNote(note: Note, completion: @escaping ((Note) -> Void)) {
        let noteRequestModel = mapRequest(note: note)
        guard let url = URL(string: "https://api.todoist.com/rest/v2/tasks") else { return }
        apiClient.postRequest(url: url,
                              parameters: ["clientId": "53552d946dcc437e91b3e1658b4de597"],
                              data: noteRequestModel) { [self] (result: Result<NoteModelResponse?, Error>) in
            switch result {
            case let .success(noteResponse):
                guard let response = noteResponse else {return}
                guard self.dictonaryNotes[(response.id!)] == nil else {
                    self.dictonaryNotes.updateValue(note.completed, forKey: (response.id)!)
                    return
                }
                let noteModel = mapResponse(noteResponse: response)
                completion(noteModel)
            case .failure(_):
                print("Error")
            }
        }
    }
    
    func removeNote(id: String, completion: @escaping (([Note]) -> Void)) {
        guard let url = URL(string: "https://api.todoist.com/rest/v2/tasks/\(id)") else { return }
        apiClient.deleteRequest(url: url,
                                parameters: ["clientId": "53552d946dcc437e91b3e1658b4de597"])
        { (result: Result<NoteModelResponse?, Error>) in
            switch result {
            case .success(_):
                var index = 0
                for note in self.notes {
                    if id == note.id {
                        self.notes.remove(at: index)
                        self.dictonaryNotes.removeValue(forKey: note.id)
                        
                        completion(self.notes)
                        break
                    }
                    index += 1
                }
            case .failure(_):
                print("Error")
            }
        }
    }
    
    func getAllNotes(completion: @escaping (([Note]) -> Void)) {
        let url = URL(string: "https://api.todoist.com/rest/v2/tasks")
        apiClient.getRequest(url: url, parameters: ["clientId": "53552d946dcc437e91b3e1658b4de597"])
        { (result: Result<Array<NoteModelResponse>?, Error>) in
            switch result {
            case let .success(notes):
                if self.dictonaryNotes.isEmpty {
                    for i in notes! {
                        self.dictonaryNotes.updateValue(i.isCompleted!, forKey: i.id!)
                    }
                }
                let allNotes = self.mapAllNotes(noteResponse: notes!)
                self.notes = allNotes
                
                completion(allNotes)
            case .failure(_):
                print("error")
            }
        }
    }
}

//MARK: private NoteStorage FUNC

private extension NoteStorage {
    
    func mapRequest(note: Note) -> NoteModelRequest {
        let noteRequest = NoteModelRequest(content: note.title,
                                           description: note.description,
                                           isCompleted: note.completed)
        return noteRequest
    }
    
    func mapResponse(noteResponse: NoteModelResponse) -> Note {
        let noteResponse = Note(description: noteResponse.description!,
                                title: noteResponse.content!,
                                id: noteResponse.id!,
                                completed: dictonaryNotes[noteResponse.id!] ?? false)
        
        return noteResponse
    }
    
    func mapAllNotes(noteResponse: [NoteModelResponse]) -> [Note] {
        let notesArray = noteResponse.enumerated().map { response -> Note in
            let note = self.mapResponse(noteResponse: response.element)
            return note
        }
        notes = notesArray
        return notes
    }
}
