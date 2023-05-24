import Foundation

struct NoteResponse: Decodable {
    
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
