import Foundation

struct Note {
    
    var title: String
    var description: String
    var id: String
    var completed: Bool
    
    init(description: String, title: String, id: String, completed: Bool) {
        self.description = description
        self.title = title
        self.completed = completed
        self.id = id
    }
}
