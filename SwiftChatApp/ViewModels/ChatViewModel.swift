import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var currentChat: Chat?
    @Published var messages: [Message] = []
    @Published var currentUser: User
    
    // Mock data for demo purposes
    init() {
        // Mock current user
        self.currentUser = User(id: "user1", name: "Me", email: "me@example.com", status: .online)
        
        // Generate mock chats
        generateMockData()
    }
    
    func generateMockData() {
        // Create some mock users
        let user2 = User(id: "user2", name: "Alice", email: "alice@example.com", status: .online)
        let user3 = User(id: "user3", name: "Bob", email: "bob@example.com", status: .away)
        let user4 = User(id: "user4", name: "Team Chat", email: "team@example.com", status: .online)
        
        // Create some mock chats
        let chat1 = Chat(id: UUID(), participants: [currentUser.id, user2.id], lastMessage: "Hey, how are you?", lastMessageTimestamp: Date().addingTimeInterval(-60*20), unreadCount: 1, title: user2.name)
        
        let chat2 = Chat(id: UUID(), participants: [currentUser.id, user3.id], lastMessage: "Let's catch up soon", lastMessageTimestamp: Date().addingTimeInterval(-60*60*3), unreadCount: 0, title: user3.name)
        
        let chat3 = Chat(id: UUID(), participants: [currentUser.id, user2.id, user3.id, user4.id], lastMessage: "Meeting at 3pm", lastMessageTimestamp: Date().addingTimeInterval(-60*60*24), unreadCount: 2, title: "Project Team")
        
        self.chats = [chat1, chat2, chat3]
    }
    
    func loadMessages(for chatID: UUID) {
        // In a real app, this would load messages from a database or API
        // For this example, we'll generate mock messages
        
        if let chat = chats.first(where: { $0.id == chatID }) {
            currentChat = chat
            
            // Generate some mock messages for the selected chat
            let mockMessages = generateMockMessages(for: chat)
            self.messages = mockMessages
            
            // Mark as read
            markChatAsRead(chatID: chatID)
        }
    }
    
    private func generateMockMessages(for chat: Chat) -> [Message] {
        var mockMessages: [Message] = []
        
        // Determine the other participant
        let otherParticipantID = chat.participants.first { $0 != currentUser.id } ?? ""
        let otherParticipantName = chat.title
        
        // Create mock message history
        let now = Date()
        mockMessages.append(Message(content: "Hi there!", senderID: currentUser.id, senderName: currentUser.name, timestamp: now.addingTimeInterval(-3600), isCurrentUser: true))
        
        mockMessages.append(Message(content: "Hey! How's it going?", senderID: otherParticipantID, senderName: otherParticipantName, timestamp: now.addingTimeInterval(-3500), isCurrentUser: false))
        
        mockMessages.append(Message(content: "Pretty good, thanks! Just working on a new app.", senderID: currentUser.id, senderName: currentUser.name, timestamp: now.addingTimeInterval(-3400), isCurrentUser: true))
        
        mockMessages.append(Message(content: "That sounds interesting. What kind of app?", senderID: otherParticipantID, senderName: otherParticipantName, timestamp: now.addingTimeInterval(-3300), isCurrentUser: false))
        
        mockMessages.append(Message(content: "A chat app with SwiftUI. It's coming along nicely!", senderID: currentUser.id, senderName: currentUser.name, timestamp: now.addingTimeInterval(-3200), isCurrentUser: true))
        
        // Add the last message from the chat
        mockMessages.append(Message(content: chat.lastMessage, senderID: otherParticipantID, senderName: otherParticipantName, timestamp: chat.lastMessageTimestamp, isCurrentUser: false))
        
        return mockMessages.sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    func sendMessage(_ content: String) {
        guard let currentChat = currentChat, !content.isEmpty else { return }
        
        // Create a new message
        let newMessage = Message(
            content: content,
            senderID: currentUser.id,
            senderName: currentUser.name,
            timestamp: Date(),
            isCurrentUser: true
        )
        
        // Add to messages list
        messages.append(newMessage)
        
        // Update the chat with the latest message
        updateChatWithLatestMessage(chatID: currentChat.id, message: newMessage)
        
        // In a real app, you would send this message to a server
        // For now, we'll just add a mock reply after a delay
        mockReply(to: newMessage, in: currentChat)
    }
    
    private func updateChatWithLatestMessage(chatID: UUID, message: Message) {
        if let index = chats.firstIndex(where: { $0.id == chatID }) {
            var updatedChat = chats[index]
            updatedChat.lastMessage = message.content
            updatedChat.lastMessageTimestamp = message.timestamp
            
            // If not current user, increment unread count
            if !message.isCurrentUser {
                updatedChat.unreadCount += 1
            }
            
            chats[index] = updatedChat
            
            // If this is the current chat, update it too
            if currentChat?.id == chatID {
                currentChat = updatedChat
            }
            
            // Sort chats by most recent message
            sortChatsByRecent()
        }
    }
    
    private func markChatAsRead(chatID: UUID) {
        if let index = chats.firstIndex(where: { $0.id == chatID }) {
            var updatedChat = chats[index]
            updatedChat.unreadCount = 0
            chats[index] = updatedChat
            
            // If this is the current chat, update it too
            if currentChat?.id == chatID {
                currentChat = updatedChat
            }
        }
    }
    
    private func sortChatsByRecent() {
        chats.sort(by: { $0.lastMessageTimestamp > $1.lastMessageTimestamp })
    }
    
    private func mockReply(to message: Message, in chat: Chat) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Only reply if we're still in the same chat
            guard self.currentChat?.id == chat.id else { return }
            
            // Get other participant info
            let otherParticipantID = chat.participants.first { $0 != self.currentUser.id } ?? ""
            let otherParticipantName = chat.title
            
            // Generate a mock reply
            let replies = [
                "That's interesting!",
                "Thanks for letting me know.",
                "Cool! What else?",
                "I see. Tell me more about that.",
                "Got it. Let's discuss this further soon."
            ]
            
            let replyContent = replies.randomElement() ?? "OK"
            
            let reply = Message(
                content: replyContent,
                senderID: otherParticipantID,
                senderName: otherParticipantName,
                timestamp: Date(),
                isCurrentUser: false
            )
            
            // Add reply to messages
            self.messages.append(reply)
            
            // Update chat with latest message
            self.updateChatWithLatestMessage(chatID: chat.id, message: reply)
        }
    }
}
