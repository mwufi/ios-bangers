import SwiftUI

struct WorkSessionsView: View {
    @StateObject private var viewModel = WorkSessionViewModel()
    @State private var selectedSession: WorkSession?
    @State private var isShowingNewSession = false
    @State private var newSessionName = ""
    @State private var newSessionCategory = ""
    
    var body: some View {
        NavigationView {
            List {
                if !viewModel.activeSessions.isEmpty {
                    Section("Active Sessions") {
                        ForEach(viewModel.activeSessions) { session in
                            ActiveSessionRow(session: session, viewModel: viewModel)
                        }
                    }
                }
                
                Section("Past Sessions") {
                    ForEach(viewModel.pastSessions) { session in
                        NavigationLink {
                            SessionDetailView(session: session)
                        } label: {
                            PastSessionRow(session: session)
                        }
                    }
                }
            }
            .navigationTitle("Work Sessions")
            .toolbar {
                Button {
                    isShowingNewSession = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isShowingNewSession) {
                NavigationView {
                    Form {
                        TextField("Session Name", text: $newSessionName)
                        TextField("Category (Optional)", text: $newSessionCategory)
                    }
                    .navigationTitle("New Session")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isShowingNewSession = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Start") {
                                Task {
                                    await viewModel.createSession(
                                        name: newSessionName,
                                        category: newSessionCategory.isEmpty ? nil : newSessionCategory
                                    )
                                    isShowingNewSession = false
                                    newSessionName = ""
                                    newSessionCategory = ""
                                }
                            }
                            .disabled(newSessionName.isEmpty)
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.fetchSessions()
            }
        }
    }
}

struct ActiveSessionRow: View {
    let session: WorkSession
    let viewModel: WorkSessionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(session.name)
                    .font(.headline)
                if let project = session.project {
                    Text("in")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(project.name)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                Spacer()
                Text(viewModel.formatDuration(session.elapsedTime))
                    .monospacedDigit()
                    .foregroundColor(.orange)
            }
            
            if let category = session.category {
                Text(category)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .swipeActions {
            Button(role: .destructive) {
                Task {
                    await viewModel.endSession(session)
                }
            } label: {
                Label("End", systemImage: "stop.fill")
            }
        }
    }
}

struct PastSessionRow: View {
    let session: WorkSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(session.name)
                    .font(.headline)
                if let project = session.project {
                    Text("in")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(project.name)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            HStack {
                if let category = session.category {
                    Text(category)
                }
                Spacer()
                Text(session.createdAt, style: .date)
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct SessionDetailView: View {
    let session: WorkSession
    @StateObject private var projectService = ProjectService()
    @State private var relatedSessions: [WorkSession] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let project = session.project {
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
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Session Details")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        LabeledContent("Name", value: session.name)
                        if let category = session.category {
                            LabeledContent("Category", value: category)
                        }
                        LabeledContent("Started", value: session.createdAt, format: .dateTime)
                        if let endedAt = session.endedAt {
                            LabeledContent("Ended", value: endedAt, format: .dateTime)
                        }
                        if let duration = session.duration {
                            LabeledContent("Duration", value: "\(duration) seconds")
                        }
                        if let target = session.target {
                            LabeledContent("Target", value: "\(target)")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    if !relatedSessions.isEmpty {
                        Text("Other Sessions in this Project")
                            .font(.headline)
                        
                        ForEach(relatedSessions) { relatedSession in
                            if relatedSession.id != session.id {
                                VStack(alignment: .leading) {
                                    Text(relatedSession.name)
                                        .font(.subheadline)
                                    Text(relatedSession.createdAt, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let projectId = session.projectId {
                do {
                    relatedSessions = try await projectService.fetchProjectSessions(projectId)
                } catch {
                    print("Error fetching related sessions: \(error)")
                }
            }
        }
    }
}

#Preview {
    WorkSessionsView()
}
