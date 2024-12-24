import SwiftUI

struct WorkSessionsView: View {
    @StateObject private var viewModel = WorkSessionViewModel()
    @State private var selectedSession: WorkSession?
    @State private var isShowingNewSession = false
    @State private var newSessionName = ""
    @State private var newSessionCategory = ""
    
    var groupedPastSessions: [(Date, [WorkSession])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: viewModel.pastSessions) { session in
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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if !viewModel.activeSessions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Active Sessions")
                                .font(.headline)
                            
                            ForEach(viewModel.activeSessions) { session in
                                ActiveSessionRow(session: session, viewModel: viewModel)
                            }
                        }
                    }
                    
                    ForEach(groupedPastSessions, id: \.0) { date, sessions in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(formatDate(date))
                                .font(.headline)
                            
                            let sessionsByHour = Dictionary(grouping: sessions) { session in
                                Calendar.current.component(.hour, from: session.createdAt)
                            }.sorted { $0.key < $1.key }
                            
                            ForEach(sessionsByHour, id: \.0) { hour, sessions in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(formatHour(hour))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    ForEach(sessions) { session in
                                        NavigationLink {
                                            SessionDetailView(session: session)
                                        } label: {
                                            SessionBlock(session: session)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Focus")
            .toolbar {
                Button {
                    isShowingNewSession = true
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(!viewModel.activeSessions.isEmpty)
            }
            .sheet(isPresented: $isShowingNewSession) {
                ProjectSelectionView(isPresented: $isShowingNewSession)
            }
            .refreshable {
                await viewModel.fetchSessions()
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

struct SessionBlock: View {
    let session: WorkSession
    @Environment(\.colorScheme) var colorScheme
    
    private var isLongSession: Bool {
        session.elapsedTime >= 15 * 60 // 30 minutes
    }
    
    private var sessionDuration: String {
        let minutes = Int(session.elapsedTime / 60)
        if minutes < 60 {
            return "\(minutes)m"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            if remainingMinutes == 0 {
                return "\(hours)h"
            }
            return "\(hours)h \(remainingMinutes)m"
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            if let project = session.project {
                Circle()
                    .fill(project.color?.color ?? .blue)
                    .frame(width: 8, height: 8)
            }
            
            VStack(alignment: .leading, spacing: isLongSession ? 4 : 2) {
                HStack {
                    Text(session.name)
                        .font(isLongSession ? .subheadline : .caption)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    if let project = session.project {
                        Text("•")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        NavigationLink(destination: ProjectDetailView(project: project)) {
                            Text(project.name)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                if isLongSession {
                    Text(sessionDuration)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if !isLongSession {
                Text(sessionDuration)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

struct ActiveSessionRow: View {
    let session: WorkSession
    let viewModel: WorkSessionViewModel
    @State private var isFlipped = false
    @State private var degree: Double = 0
    
    var body: some View {
        ZStack {
            // Front side
            frontView
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(degree), axis: (x: 0, y: 1, z: 0))
            
            // Back side
            backView
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(degree + 180), axis: (x: 0, y: 1, z: 0))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                degree += 180
                isFlipped.toggle()
            }
        }
    }
    
    private var frontView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let project = session.project {
                    Circle()
                        .fill(project.color?.color ?? .blue)
                        .frame(width: 12, height: 12)
                }
                
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
                    .font(.subheadline)
                    .monospacedDigit()
            }
            
            if let category = session.category {
                Text(category)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var backView: some View {
        VStack(spacing: 12) {
            Text("End this session?")
                .font(.headline)
            
            HStack(spacing: 16) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        degree += 180
                        isFlipped.toggle()
                    }
                }) {
                    Text("Cancel")
                        .foregroundColor(.secondary)
                }
                
                Button(action: {
                    Task {
                        await viewModel.endSession(session)
                    }
                }) {
                    Text("End Session")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
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
