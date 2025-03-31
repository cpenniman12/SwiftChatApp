import SwiftUI

struct ChatDetailView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    let chatID: UUID
    @State private var messageText: String = ""
    @FocusState private var isInputFocused: Bool
    
    // For handling scrolling to bottom
    @State private var scrollToBottom = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat messages
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(chatViewModel.messages) { message in
                            MessageBubbleView(message: message)
                                .id(message.id)
                        }
                        
                        // Invisible view at bottom to scroll to
                        Color.clear
                            .frame(height: 1)
                            .id("bottom")
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .onChange(of: chatViewModel.messages.count) { _ in
                    withAnimation {
                        scrollView.scrollTo("bottom", anchor: .bottom)
                    }
                }
                .onAppear {
                    // Load messages for this chat
                    chatViewModel.loadMessages(for: chatID)
                    
                    // Scroll to bottom after a short delay to ensure content is loaded
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            scrollView.scrollTo("bottom", anchor: .bottom)
                        }
                    }
                }
            }
            
            // Message input
            HStack(spacing: 12) {
                TextField("Message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 8)
                    .focused($isInputFocused)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                        )
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(UIColor.systemGray4))
                    .opacity(0.5),
                alignment: .top
            )
        }
        .navigationTitle(chatViewModel.currentChat?.title ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            // Reset current chat when navigating away
            chatViewModel.currentChat = nil
        }
    }
    
    private func sendMessage() {
        let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        chatViewModel.sendMessage(trimmedText)
        messageText = ""
    }
}

struct MessageBubbleView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isCurrentUser {
                Spacer()
            }
            
            VStack(alignment: message.isCurrentUser ? .trailing : .leading, spacing: 4) {
                // Sender name (only show for group chats)
                if !message.isCurrentUser {
                    Text(message.senderName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading, 8)
                }
                
                // Message content
                Text(message.content)
                    .foregroundColor(message.isCurrentUser ? .white : .primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        message.isCurrentUser ? 
                            Color.blue : 
                            Color(UIColor.systemGray6)
                    )
                    .cornerRadius(16)
                
                // Timestamp
                Text(formatTime(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
            }
            
            if !message.isCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal, 8)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a preview with a mock chat
        let viewModel = ChatViewModel()
        let chat = viewModel.chats.first!
        
        return NavigationView {
            ChatDetailView(chatID: chat.id)
                .environmentObject(viewModel)
        }
    }
}
