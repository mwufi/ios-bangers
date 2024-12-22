import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    @Environment(\.dismiss) private var dismiss
    @Binding var activeSession: Session?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Image
                Image(systemName: "mountain.2.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
                    .overlay(
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .padding(),
                        alignment: .topLeading
                    )
                
                VStack(alignment: .leading, spacing: 16) {
                    // Project Info
                    Text(project.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(project.description)
                        .foregroundColor(.secondary)
                    
                    // Past Sessions
                    Text("Past Sessions")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)
                    
                    ForEach(project.sessions) { session in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(session.startTime.formatted(date: .abbreviated, time: .shortened))
                                if let endTime = session.endTime {
                                    Text("Duration: \(endTime.timeIntervalSince(session.startTime).formatted()) minutes")
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("Ongoing")
                                        .foregroundColor(.orange)
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                    }
                    
                    // Start Session Button
                    Button(action: {
                        activeSession = Session(startTime: Date())
                        dismiss()
                    }) {
                        Text("Start Session")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea()
    }
}

#Preview("Empty Project") {
    NavigationView {
        ProjectDetailView(
            project: Project(
                name: "New Project",
                description: "Just getting started"
            ),
            activeSession: .constant(nil)
        )
    }
}

#Preview("With Sessions") {
    NavigationView {
        ProjectDetailView(
            project: Project(
                name: "Reading",
                description: "Daily reading sessions",
                sessions: [
                    Session(
                        startTime: Date().addingTimeInterval(-3600),
                        endTime: Date()
                    ),
                    Session(
                        startTime: Date().addingTimeInterval(-7200),
                        endTime: Date().addingTimeInterval(-3600)
                    )
                ]
            ),
            activeSession: .constant(nil)
        )
    }
}

#Preview("With Active Session") {
    NavigationView {
        ProjectDetailView(
            project: Project(
                name: "Meditation",
                description: "Daily mindfulness practice"
            ),
            activeSession: .constant(Session(startTime: Date()))
        )
    }
}
