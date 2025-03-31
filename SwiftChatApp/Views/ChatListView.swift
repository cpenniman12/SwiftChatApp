import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    var body: some View {
        List {
            ForEach(chatViewModel.chats) { chat in
                NavigationLink(destination: ChatDetailView(chatID: chat.id)) {
                    ChatRowView(chat: chat)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Chats")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
    }
}

struct ChatRowView: View {
    let chat: Chat
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile image
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                
                Text(String(chat.title.prefix(1)))
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .frame(width: 50, height: 50)
            
            // Chat info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(chat.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Time
                    Text(formatTimeAgo(chat.lastMessageTimestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    // Last message
                    Text(chat.lastMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Unread count
                    if chat.unreadCount > 0 {
                        Text("\(chat.unreadCount)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)
                            .frame(minWidth: 20, minHeight: 20)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    // Format time ago for display
    private func formatTimeAgo(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatListView()
                .environmentObject(ChatViewModel())
        }
    }
}
