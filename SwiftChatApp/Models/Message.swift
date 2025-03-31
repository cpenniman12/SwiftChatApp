import Foundation

struct Message: Identifiable, Codable, Equatable {
    var id: UUID
    var content: String
    var senderID: String
    var senderName: String
    var timestamp: Date
    var isCurrentUser: Bool
    
    init(id: UUID = UUID(), content: String, senderID: String, senderName: String, timestamp: Date = Date(), isCurrentUser: Bool) {
        self.id = id
        self.content = content
        self.senderID = senderID
        self.senderName = senderName
        self.timestamp = timestamp
        self.isCurrentUser = isCurrentUser
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}
