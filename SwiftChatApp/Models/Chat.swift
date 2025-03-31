import Foundation

struct Chat: Identifiable, Codable, Equatable {
    var id: UUID
    var participants: [String] // User IDs
    var lastMessage: String
    var lastMessageTimestamp: Date
    var unreadCount: Int
    var title: String
    
    init(id: UUID = UUID(), participants: [String], lastMessage: String = "", lastMessageTimestamp: Date = Date(), unreadCount: Int = 0, title: String) {
        self.id = id
        self.participants = participants
        self.lastMessage = lastMessage
        self.lastMessageTimestamp = lastMessageTimestamp
        self.unreadCount = unreadCount
        self.title = title
    }
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }
}
