import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WorkSessionsView()
                .tabItem {
                    Label("Focus", systemImage: "timer")
                }
                .tag(0)
            
            ProjectsView()
                .tabItem {
                    Label("Projects", systemImage: "folder")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
    }
}

#Preview {
    MainTabView()
}
