import SwiftUI
import PhotosUI
import Storage

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
    @State private var selectedItem: PhotosPickerItem?
    private let auth = AuthenticationService.shared
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
                    ZStack(alignment: .topTrailing) {
                        AsyncImage(url: URL(string: headerImg)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                        }
                        .frame(height: 200)
                        .clipped()
                        
                        PhotosPicker(selection: $selectedItem,
                                   matching: .images) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        .padding(8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(project.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    if let description = project.description {
                        Text(description)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("Total Time: \(formatDuration(totalTime))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
                .padding(.horizontal)
                
                ForEach(sessionsByDay, id: \.0) { date, daySessions in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(formatDate(date))
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        ForEach(daySessions) { session in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(session.name)
                                        .font(.headline)
                                    
                                    if let category = session.category {
                                        Text(category)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                Text(formatDuration(session.elapsedTime))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    do {
                        print("📸 Image data loaded, size: \(data.count) bytes")
                        
                        // Generate a unique filename
                        let fileName = "project-headers/\(UUID().uuidString).png"
                        print("📝 Generated filename: \(fileName)")
                        
                        // Upload to Supabase storage
                        print("⬆️ Starting upload to project-images bucket...")
                        try await auth.supabase.storage
                            .from("project-images")
                            .upload(
                                path: fileName,
                                file: data,
                                options: FileOptions(
                                    cacheControl: "3600",
                                    contentType: "image/png",
                                    upsert: false
                                )
                            )
                        print("✅ Upload successful!")
                        
                        // Get the public URL
                        print("🔗 Getting public URL...")
                        let publicURL = try await auth.supabase.storage
                            .from("project-images")
                            .getPublicURL(path: fileName)
                        print("📍 Public URL: \(publicURL)")
                        
                        // Update the project with new header image
                        print("📝 Updating project with new header image...")
                        try await auth.supabase
                            .from("projects")
                            .update(["header_img": publicURL])
                            .eq("id", value: project.id)
                            .execute()
                        print("✨ Project updated successfully!")
                        
                        // Refresh the view
                        sessions = try await projectService.fetchProjectSessions(project.id)
                        print("🔄 View refreshed with new data")
                    } catch {
                        print("❌ Error during image upload process: \(error)")
                    }
                } else {
                    print("⚠️ Failed to load image data from picker")
                }
            }
        }
        .task {
            do {
                sessions = try await projectService.fetchProjectSessions(project.id)
            } catch {
                print("Error fetching sessions: \(error)")
            }
        }
    }
}

#Preview {
    ProjectsView()
}
