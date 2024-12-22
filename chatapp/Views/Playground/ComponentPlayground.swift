import SwiftUI

struct ComponentCategory: Identifiable {
    let id = UUID()
    let name: String
    let components: [PlaygroundComponent]
}

struct PlaygroundComponent: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let view: AnyView
}

struct ComponentPlayground: View {
    @State private var selectedCategory: String?
    
    let categories: [ComponentCategory] = [
        ComponentCategory(name: "Cards", components: [
            PlaygroundComponent(
                name: "Session Card",
                description: "Horizontal scrolling card with image and overlay text",
                view: AnyView(
                    SessionCard(
                        title: "Morning Focus",
                        subtitle: "Start your day with intention",
                        imageName: "sunrise.fill"
                    ) {}
                )
            ),
            PlaygroundComponent(
                name: "Minimal Session Card",
                description: "Compact card showing basic session info",
                view: AnyView(
                    MinimalSessionCard(
                        title: "Quick Focus",
                        duration: 1800
                    ) {}
                )
            ),
            PlaygroundComponent(
                name: "Gradient Session Card",
                description: "Beautiful gradient card with glass-effect button",
                view: AnyView(
                    GradientSessionCard(
                        title: "Evening Meditation",
                        subtitle: "Clear your mind before sleep",
                        gradient: LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    ) {}
                )
            ),
            PlaygroundComponent(
                name: "Stats Session Card",
                description: "Card showing session statistics",
                view: AnyView(
                    StatsSessionCard(
                        title: "This Week",
                        sessionsCount: 12,
                        totalTime: 7200
                    ) {}
                )
            ),
            PlaygroundComponent(
                name: "Project Card",
                description: "Compact project card with action button",
                view: AnyView(
                    ProjectCard(
                        project: Project(
                            name: "Example Project",
                            description: "This is an example project card"
                        )
                    ) {}
                )
            )
        ]),
        
        ComponentCategory(name: "Overlays", components: [
            PlaygroundComponent(
                name: "Session Toast",
                description: "Bottom overlay showing active session",
                view: AnyView(
                    SessionToast(
                        session: Session(startTime: Date()),
                        projectName: "Example Project"
                    )
                )
            )
        ]),
        
        ComponentCategory(name: "Navigation", components: [
            PlaygroundComponent(
                name: "Tab Menu",
                description: "Horizontal scrolling tab menu with indicators",
                view: AnyView(
                    TabMenuExample()
                )
            )
        ])
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    Section(header: Text(category.name)) {
                        ForEach(category.components) { component in
                            NavigationLink(destination: ComponentDetail(component: component)) {
                                VStack(alignment: .leading) {
                                    Text(component.name)
                                        .font(.headline)
                                    Text(component.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Component Playground")
            .listStyle(.insetGrouped)
        }
    }
}

struct ComponentDetail: View {
    let component: PlaygroundComponent
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                component.view
                    .padding()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("About this component")
                        .font(.headline)
                    Text(component.description)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding()
            }
        }
        .navigationTitle(component.name)
        .background(Color(.systemGroupedBackground))
    }
}

// Example Views
struct TabMenuExample: View {
    @State private var selectedTab = "Tab 1"
    let tabs = ["Tab 1", "Tab 2", "Tab 3", "Tab 4"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(tabs, id: \.self) { tab in
                    VStack {
                        Text(tab)
                            .foregroundColor(selectedTab == tab ? .blue : .gray)
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(selectedTab == tab ? .blue : .clear)
                    }
                    .onTapGesture {
                        withAnimation { selectedTab = tab }
                    }
                }
            }
            .padding()
        }
    }
}

// Preview Data
enum PreviewData {
    static let allComponents: [PlaygroundComponent] = [
        PlaygroundComponent(
            name: "Session Card",
            description: "Standard session card",
            view: AnyView(
                SessionCard(
                    title: "Morning Focus",
                    subtitle: "Start your day with intention",
                    imageName: "sunrise.fill"
                ) {}
            )
        ),
        PlaygroundComponent(
            name: "Minimal Card",
            description: "Compact session card",
            view: AnyView(
                MinimalSessionCard(
                    title: "Quick Focus",
                    duration: 1800
                ) {}
            )
        ),
        PlaygroundComponent(
            name: "Gradient Card",
            description: "Gradient background card",
            view: AnyView(
                GradientSessionCard(
                    title: "Evening Meditation",
                    subtitle: "Clear your mind",
                    gradient: LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                ) {}
            )
        ),
        PlaygroundComponent(
            name: "Stats Card",
            description: "Statistics card",
            view: AnyView(
                StatsSessionCard(
                    title: "This Week",
                    sessionsCount: 12,
                    totalTime: 7200
                ) {}
            )
        )
    ]
}

struct ComponentPlayground_Previews: PreviewProvider {
    static var previews: some View {
        ComponentPlayground()
    }
}

struct ComponentGrid_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(PreviewData.allComponents) { component in
                        VStack {
                            component.view
                                .frame(height: 200)
                            
                            Text(component.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Component Grid")
        }
    }
}
