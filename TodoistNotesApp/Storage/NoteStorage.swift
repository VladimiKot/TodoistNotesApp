//  TodoListNotesApp
//  Created by Владимир on 18.03.2023.

import Foundation

class NoteStorage {
    
    private var notes: [Note] = []
    private let queue = DispatchQueue(label: "storageQue", attributes: .concurrent)
    
    let apiClient: APIClient = APIClient()
    let defaults = UserDefaults.standard
    
    var dictonaryNotes: [String: Bool] {
        set {
            queue.async(flags: .barrier) { [weak self] in
                self?.defaults.set(newValue, forKey: "dictionaryNotes")
            }
        }
        get {
            queue.sync {
                let retrieveDictionaryNotes = defaults.object(forKey: "dictionaryNotes") as? [String: Bool] ?? [String: Bool]()
                return retrieveDictionaryNotes
            }
        }
    }
}

// MARK: NoteStorageProtocol

extension NoteStorage : NoteStorageProtocol {
    
    func update(note: Note) -> [Note] {
        let updatedNotes = notes.map { storedNote -> Note in
            if note.id == storedNote.id {
                return note
            }
            return storedNote
        }
        self.dictonaryNotes.updateValue(note.completed, forKey: note.id)
        notes = updatedNotes

        return notes
    }
    
    func addNote(note: Note, completion: @escaping ((Note) -> Void)) {
        let noteRequestModel = mapRequest(note: note)
        guard let url = URL(string: "https://api.todoist.com/rest/v2/tasks") else { return }
        apiClient.postRequest(url: url,
                              parameters: ["clientId": "53552d946dcc437e91b3e1658b4de597"],
                              data: noteRequestModel) { [weak self] (result: Result<NoteModelResponse?, Error>) in
            switch result {
            case let .success(noteResponse):
                guard let response = noteResponse else {return}
                if self?.dictonaryNotes[response.id!] == nil {
                    self?.dictonaryNotes.updateValue(note.completed, forKey: (response.id)!)
                }
                guard let noteModel = self?.mapResponse(noteResponse: response) else {return}
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
        { [weak self] (result: Result<NoteModelResponse?, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                let filteredNotes = self.notes.filter { $0.id != id }
                self.notes = filteredNotes
                self.dictonaryNotes.removeValue(forKey: id)
                completion(filteredNotes)

            case .failure(_):
                print("Error")
            }
        }
    }
    
    func getAllNotes(completion: @escaping (([Note]) -> Void)) {
        let url = URL(string: "https://api.todoist.com/rest/v2/tasks")
        apiClient.getRequest(url: url, parameters: ["clientId": "53552d946dcc437e91b3e1658b4de597"])
        {  (result: Result<Array<NoteModelResponse>?, Error>) in
            switch result {
            case let .success(notesResponse):
                guard let notesResponse = notesResponse else {return}
                if self.dictonaryNotes.isEmpty {
                    notesResponse.forEach({ notesResponse in
                        self.dictonaryNotes.updateValue(notesResponse.isCompleted!, forKey: notesResponse.id!)
                    })
                }
                let notesArray = notesResponse.map { note in
                    self.mapResponse(noteResponse: note)
                }
                self.notes = notesArray
                completion(notesArray)

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
}
