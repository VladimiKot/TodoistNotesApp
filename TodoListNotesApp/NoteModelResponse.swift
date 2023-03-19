//  TodoListNotesApp
//  Created by Владимир on 18.03.2023.

import Foundation

struct NoteModelResponse: Decodable {
    enum CodingKeys: String, CodingKey {

        case isCompleted = "is_completed"
        case content
        case description
        case id
    }
    
    var isCompleted: Bool?
    var content: String?
    var description: String?
    var id: String?
    
}
