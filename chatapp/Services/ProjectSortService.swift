import Foundation

class ProjectSortService {
    static let shared = ProjectSortService()
    private init() {}
    
    enum SortStrategy {
        case recentlyCreated
        case recentlyUsed(sessions: [WorkSession])
        case alphabetical
    }
    
    func sortProjects(_ projects: [Project], by strategy: SortStrategy) -> [Project] {
        switch strategy {
        case .recentlyCreated:
            return projects.sorted { $0.createdAt > $1.createdAt }
            
        case .recentlyUsed(let sessions):
            let projectIds = sessions
                .sorted { $0.createdAt > $1.createdAt }
                .compactMap { $0.projectId }
            
            // Remove duplicates while preserving order
            let uniqueProjectIds = Array(NSOrderedSet(array: projectIds))
                .compactMap { $0 as? Int }
            
            // Create a dictionary for quick project lookup
            let projectDict = Dictionary(uniqueKeysWithValues: projects.map { ($0.id, $0) })
            
            // Map IDs to projects, maintaining order
            let sortedProjects = uniqueProjectIds.compactMap { projectDict[$0] }
            
            // Add any remaining projects at the end, sorted by creation date
            let remainingProjects = projects
                .filter { project in !sortedProjects.contains { $0.id == project.id } }
                .sorted { $0.createdAt > $1.createdAt }
            
            return sortedProjects + remainingProjects
            
        case .alphabetical:
            return projects.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }
    
    func recentProjects(_ projects: [Project], sessions: [WorkSession], limit: Int = 2) -> [Project] {
        return sortProjects(projects, by: .recentlyUsed(sessions: sessions))
            .prefix(limit)
            .map { $0 }
    }
}
