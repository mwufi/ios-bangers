import Foundation

class ProjectViewModel: ObservableObject {
    @Published var projects: [Project] = [
        Project(name: "Exercise!", description: "Ready to continue your progress? Start a new session!"),
        Project(name: "ios app", description: "Ready to continue your progress? Start a new session!"),
        Project(name: "travel", description: "Ready to continue your progress? Start a new session!"),
        Project(name: "morning!! ☀️", description: "wake up in the morning"),
        Project(name: "Flow app", description: "this app!")
    ]
    
    func startNewSession(for project: Project) {
        var updatedProject = project
        let newSession = Session(startTime: Date())
        updatedProject.sessions.append(newSession)
        
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects[index] = updatedProject
        }
    }
}
