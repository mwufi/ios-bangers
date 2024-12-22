import SwiftUI

struct ProjectCard: View {
    let project: Project
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(project.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: action) {
                    Text("New Session")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

#Preview("Default") {
    ProjectCard(
        project: Project(
            name: "Morning Routine",
            description: "Start your day with intention"
        )
    ) {}
}

#Preview("With Sessions") {
    ProjectCard(
        project: Project(
            name: "Evening Focus",
            description: "Deep work session",
            sessions: [
                Session(startTime: Date().addingTimeInterval(-3600)),
                Session(startTime: Date().addingTimeInterval(-7200))
            ]
        )
    ) {}
}

#Preview("Grid") {
    VStack(spacing: 16) {
        ProjectCard(
            project: Project(
                name: "Project 1",
                description: "Description 1"
            )
        ) {}
        
        ProjectCard(
            project: Project(
                name: "Project 2",
                description: "Description 2"
            )
        ) {}
    }
    .padding()
}
