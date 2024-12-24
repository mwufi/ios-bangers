import Foundation

struct WorkSession: Identifiable, Codable {
    let id: Int
    let createdAt: Date
    let name: String
    let category: String?
    let duration: Int?
    let projectId: Int?
    let project: Project?
    let endedAt: Date?
    let target: Int?
    let editedDuration: Int?
    let createdBy: UUID
    
    var isActive: Bool {
        return endedAt == nil
    }
    
    var elapsedTime: TimeInterval {
        if let endedAt = endedAt {
            return endedAt.timeIntervalSince(createdAt)
        }
        return Date().timeIntervalSince(createdAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case name
        case category
        case duration
        case projectId = "project_id"
        case project
        case endedAt = "ended_at"
        case target
        case editedDuration = "edited_duration"
        case createdBy = "created_by"
    }
}
