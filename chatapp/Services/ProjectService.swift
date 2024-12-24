import Foundation
import Supabase

struct NewProject: Codable {
    let name: String
    let description: String?
    let headerImg: String?
    let isPublic: Bool
    let isOpen: Bool
    let createdBy: UUID
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case headerImg = "header_img"
        case isPublic = "is_public"
        case isOpen = "is_open"
        case createdBy = "created_by"
    }
}

class ProjectService: ObservableObject {
    private let auth = AuthenticationService.shared
    
    func fetchProjects() async throws -> [Project] {
        return try await auth.supabase
            .from("projects")
            .select()
            .order("created_at", ascending: false)
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
            .select("*, project(*)")
            .eq("project_id", value: projectId)
            .execute()
            .value
    }
    
    func updateProject(id: Int, headerImg: String) async throws {
        try await auth.supabase
            .from("projects")
            .update(["header_img": headerImg])
            .eq("id", value: id)
            .execute()
    }
    
    func createProject(name: String, description: String?, headerImg: String?, isPublic: Bool, isOpen: Bool) async throws -> Project {
        guard let userId = auth.currentUser?.id else {
            throw AuthError.notAuthenticated
        }
        
        return try await auth.supabase
            .from("projects")
            .insert(NewProject(
                name: name,
                description: description,
                headerImg: headerImg,
                isPublic: isPublic,
                isOpen: isOpen,
                createdBy: userId
            ))
            .select()
            .single()
            .execute()
            .value
    }
}
