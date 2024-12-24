import SwiftUI

struct ProjectSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var projectService = ProjectService()
    @StateObject private var sessionService = WorkSessionViewModel()
    @State private var projects: [Project] = []
    @State private var sessions: [WorkSession] = []
    @State private var selectedProject: Project?
    @State private var isShowingNewSession = false
    
    private let sortService = ProjectSortService.shared
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var recentProjects: [Project] {
        let allSessions = sessionService.pastSessions + sessionService.activeSessions
        return sortService.recentProjects(projects, sessions: allSessions)
    }
    
    var allProjects: [Project] {
        sortService.sortProjects(projects, by: .recentlyCreated)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if !recentProjects.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("RECENT")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(recentProjects) { project in
                                    ProjectCard(project: project) {
                                        selectedProject = project
                                        isShowingNewSession = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("ALL PROJECTS")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(allProjects) { project in
                                ProjectCard(project: project) {
                                    selectedProject = project
                                    isShowingNewSession = true
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("New Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $isShowingNewSession) {
                if let project = selectedProject {
                    NewSessionView(project: project)
                }
            }
        }
        .task {
            do {
                async let projectsTask = projectService.fetchProjects()
                async let sessionsTask = sessionService.fetchSessions()
                
                projects = try await projectsTask
                await sessionsTask
                sessions = sessionService.pastSessions + sessionService.activeSessions
            } catch {
                print("Error fetching data: \(error)")
            }
        }
    }
}

struct ProjectCard: View {
    let project: Project
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    if let headerImg = project.headerImg {
                        AsyncImage(url: URL(string: headerImg)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.width)
                                .clipped()
                        } placeholder: {
                            Rectangle()
                                .fill(project.color?.color.opacity(0.2) ?? .blue.opacity(0.2))
                        }
                    } else {
                        Rectangle()
                            .fill(project.color?.color.opacity(0.2) ?? .blue.opacity(0.2))
                    }
                    
                    Rectangle()
                        .fill(.black.opacity(0.3))
                    
                    Text(project.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct NewSessionView: View {
    let project: Project
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = WorkSessionViewModel()
    @State private var sessionName = ""
    @State private var category = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Circle()
                            .fill(project.color?.color ?? .blue)
                            .frame(width: 12, height: 12)
                        Text(project.name)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    TextField("Session Name", text: $sessionName)
                    TextField("Category (Optional)", text: $category)
                }
            }
            .navigationTitle("New Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        Task {
                            await viewModel.createSession(
                                name: sessionName,
                                category: category.isEmpty ? nil : category,
                                projectId: project.id
                            )
                            dismiss()
                        }
                    }
                    .disabled(sessionName.isEmpty)
                }
            }
        }
    }
}
