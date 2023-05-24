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
