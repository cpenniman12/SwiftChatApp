import Foundation

struct User: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var email: String
    var profileImageURL: String?
    var status: UserStatus
    
    enum UserStatus: String, Codable {
        case online
        case offline
        case away
    }
    
    init(id: String, name: String, email: String, profileImageURL: String? = nil, status: UserStatus = .offline) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImageURL = profileImageURL
        self.status = status
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
