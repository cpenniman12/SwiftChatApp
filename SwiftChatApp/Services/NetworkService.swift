import Foundation
import Combine

// This is a mock service to simulate network requests
// In a real app, this would connect to a backend service

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func sendMessage(_ message: Message, in chat: Chat) -> AnyPublisher<Bool, Error> {
        // Simulate network delay and success
        return Future<Bool, Error> { promise in
            // Simulate network latency
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                // Simulate 95% success rate for realism
                let isSuccess = Double.random(in: 0...1) < 0.95
                
                if isSuccess {
                    promise(.success(true))
                } else {
                    promise(.failure(NetworkError.failedToSend))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchMessages(for chatID: UUID) -> AnyPublisher<[Message], Error> {
        // In a real app, this would make an API request
        // Here we just return an empty array since our ViewModel handles mock data
        return Just([Message]())
            .setFailureType(to: Error.self)
            .delay(for: .seconds(0.5), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func fetchChats() -> AnyPublisher<[Chat], Error> {
        // In a real app, this would make an API request
        // Here we just return an empty array since our ViewModel handles mock data
        return Just([Chat]())
            .setFailureType(to: Error.self)
            .delay(for: .seconds(0.5), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    // For user authentication (mock)
    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            // Simulate network latency
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // For demo, accept any email with a password length >= 6
                if password.count >= 6 {
                    let user = User(
                        id: "user1",
                        name: "Demo User",
                        email: email,
                        status: .online
                    )
                    promise(.success(user))
                } else {
                    promise(.failure(NetworkError.authenticationFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// Define possible network errors
enum NetworkError: Error, LocalizedError {
    case failedToSend
    case authenticationFailed
    case connectionError
    case serverError
    
    var errorDescription: String? {
        switch self {
        case .failedToSend:
            return "Failed to send message. Please try again."
        case .authenticationFailed:
            return "Authentication failed. Please check your credentials."
        case .connectionError:
            return "Connection error. Please check your internet connection."
        case .serverError:
            return "Server error. Please try again later."
        }
    }
}
