import Foundation
import Supabase

class ProjectService: ObservableObject {
    private let auth = AuthenticationService.shared
    
    func fetchProjects() async throws -> [Project] {
        return try await auth.supabase
            .from("projects")
            .select()
            .execute()
            .value
    }
    
    func fetchProject(_ id: Int) async throws -> Project? {
        let projects: [Project] = try await auth.supabase
            .from("projects")
            .select()
            .eq("id", value: id)
            .execute()
            .value
        return projects.first
    }
    
    func fetchProjectSessions(_ projectId: Int) async throws -> [WorkSession] {
        return try await auth.supabase
            .from("work_sessions")
            .select()
            .eq("project_id", value: projectId)
            .execute()
            .value
    }
}
