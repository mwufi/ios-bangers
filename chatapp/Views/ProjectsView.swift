import SwiftUI

struct ProjectsView: View {
    @StateObject private var projectService = ProjectService()
    @State private var projects: [Project] = []
    @State private var isShowingNewProject = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
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
                                            .lineLimit(1)
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
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
    @Environment(\.colorScheme) var colorScheme
    
    var totalTime: TimeInterval {
        sessions.reduce(0) { $0 + $1.elapsedTime }
    }
    
    var sessionsByDay: [(Date, [WorkSession])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: sessions) { session in
            calendar.startOfDay(for: session.createdAt)
        }
        return grouped.sorted { $0.key > $1.key }
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
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        
        if hours > 0 {
            return minutes > 0 ? "\(hours)h \(minutes)m" : "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
    
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
                    HStack {
                        Circle()
                            .fill(project.color?.color ?? .blue)
                            .frame(width: 12, height: 12)
                        
                        Text(project.name)
                            .font(.title)
                            .bold()
                    }
                    
                    if let description = project.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("Total time: \(formatDuration(totalTime))")
                        .font(.headline)
                        .foregroundColor(.orange)
                        .padding(.top, 4)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(sessionsByDay, id: \.0) { date, daySessions in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(formatDate(date))
                                .font(.headline)
                            
                            let sessionsByHour = Dictionary(grouping: daySessions) { session in
                                Calendar.current.component(.hour, from: session.createdAt)
                            }.sorted { $0.key > $1.key }
                            
                            ForEach(sessionsByHour, id: \.0) { hour, hourSessions in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(formatHour(hour))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    ForEach(hourSessions.sorted { $0.createdAt > $1.createdAt }) { session in
                                        HStack {
                                            Text(session.name)
                                                .font(.subheadline)
                                            
                                            Spacer()
                                            
                                            Text(formatDuration(session.elapsedTime))
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.vertical, 6)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
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
    
    private func formatHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = 0
        
        if let date = Calendar.current.date(from: components) {
            return formatter.string(from: date)
        }
        return "\(hour):00"
    }
}

#Preview {
    ProjectsView()
}
