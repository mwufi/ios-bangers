import SwiftUI

struct ProjectsView: View {
    @StateObject private var projectService = ProjectService()
    @State private var projects: [Project] = []
    @State private var isShowingNewProject = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(projects) { project in
                        NavigationLink {
                            ProjectDetailView(project: project)
                        } label: {
                            ZStack {
                                // Background image
                                if let headerImg = project.headerImg {
                                    AsyncImage(url: URL(string: headerImg)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .overlay {
                                                Color(project.color?.color ?? .red)
                                                    .opacity(0.1)
                                            }
                                    } placeholder: {
                                        defaultBackground(for: project)
                                    }
                                } else {
                                    defaultBackground(for: project)
                                }
                                
                                // Centered text with shadow
                                VStack(spacing: 4) {
                                    Text(project.name)
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .multilineTextAlignment(.center)
                                    
                                    if let description = project.description {
                                        Text(description)
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .multilineTextAlignment(.center)
                                            .opacity(0.9)
                                    }
                                }
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            }
                            .frame(height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .navigationTitle("Projects")
            .toolbar {
                Button {
                    isShowingNewProject = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isShowingNewProject) {
                NewProjectView()
                    .onDisappear {
                        Task {
                            do {
                                projects = try await projectService.fetchProjects()
                            } catch {
                                print("Error refreshing projects: \(error)")
                            }
                        }
                    }
            }
            .task {
                do {
                    projects = try await projectService.fetchProjects()
                } catch {
                    print("Error fetching projects: \(error)")
                }
            }
        }
    }
    
    private func defaultBackground(for project: Project) -> some View {
        Image("Background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .overlay {
                Color(project.color?.color ?? .blue)
                    .opacity(0.1)
            }
    }
}

#Preview {
    ProjectsView()
}
