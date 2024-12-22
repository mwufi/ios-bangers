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
        ])
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    Section(header: Text(category.name)) {
                        ForEach(category.components) { component in
                            NavigationLink {
                                ComponentDetail(component: component)
                            } label: {
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

#Preview {
    ComponentPlayground()
}

#Preview("Grid") {
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
