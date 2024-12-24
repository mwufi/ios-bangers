import SwiftUI

struct SettingsView: View {
    @StateObject private var authService = AuthenticationService.shared
    
    var body: some View {
        NavigationView {
            List {
                Section("Account") {
                    if let user = authService.currentUser {
                        Text(user.email ?? "No email")
                    }
                    Button("Sign Out", role: .destructive) {
                        Task {
                            try? await authService.signOut()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
