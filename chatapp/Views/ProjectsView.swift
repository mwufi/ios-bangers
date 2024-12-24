import SwiftUI

struct ProjectsView: View {
    @StateObject private var projectService = ProjectService()
    @State private var projects: [Project] = []
    @State private var isShowingNewProject = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(projects) { project in
                        NavigationLink {
                            ProjectDetailView(project: project)
                        } label: {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(project.color?.color ?? .blue)
                                    .frame(width: 12, height: 12)
                                
                                VStack(alignment: .leading) {
                                    Text(project.name)
                                        .font(.headline)
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                    if let description = project.description {
                                        Text(description)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Projects")
            .toolbar {
                Button {
                    isShowingNewProject = true
                } label: {
                    Image(systemName: "plus")
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
}

struct ProjectDetailView: View {
    let project: Project
    @StateObject private var projectService = ProjectService()
    @State private var sessions: [WorkSession] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let headerImg = project.headerImg {
                    AsyncImage(url: URL(string: headerImg)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(.gray.opacity(0.2))
                    }
                    .frame(height: 200)
                    .clipped()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(project.name)
                        .font(.title)
                        .bold()
                    
                    if let description = project.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                if !sessions.isEmpty {
                    SessionsList(sessions: sessions)
                        .padding(.horizontal)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                sessions = try await projectService.fetchProjectSessions(project.id)
            } catch {
                print("Error fetching sessions: \(error)")
            }
        }
    }
}

struct SessionsList: View {
    let sessions: [WorkSession]
    
    var groupedSessions: [(String, [WorkSession])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: sessions) { session in
            calendar.startOfDay(for: session.createdAt)
        }
        return grouped.map { (date, sessions) in
            (formatDate(date), sessions)
        }.sorted { $0.0 > $1.0 }
    }
    
    func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
    
    var body: some View {
        ForEach(groupedSessions, id: \.0) { date, sessions in
            Section(header: Text(date).font(.headline)) {
                ForEach(sessions) { session in
                    VStack(alignment: .leading) {
                        Text(session.name)
                            .font(.subheadline)
                        if let category = session.category {
                            Text(category)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

#Preview {
    ProjectsView()
}
