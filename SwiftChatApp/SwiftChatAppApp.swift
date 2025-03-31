import SwiftUI

@main
struct SwiftChatAppApp: App {
    // App state
    @StateObject private var chatViewModel = ChatViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ChatListView()
                    .environmentObject(chatViewModel)
            }
        }
    }
}
