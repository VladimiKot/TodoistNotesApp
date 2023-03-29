//  TodoListNotesApp
//  Created by Владимир on 18.03.2023.


import Foundation

struct NoteModelRequest: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case content
        case description
        case isCompleted = "is_completed"
        
    }
    
    var content: String?
    var description: String?
    var isCompleted: Bool?
    
}
