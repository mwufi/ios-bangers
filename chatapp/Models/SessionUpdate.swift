import Foundation

struct SessionUpdate: Encodable {
    let endedAt: String?
    let editedDuration: Int?
    
    enum CodingKeys: String, CodingKey {
        case endedAt = "ended_at"
        case editedDuration = "edited_duration"
    }
}

struct NewSession: Encodable {
    let name: String
    let category: String?
    let projectId: Int?
    let createdBy: UUID
    
    enum CodingKeys: String, CodingKey {
        case name
        case category
        case projectId = "project_id"
        case createdBy = "created_by"
    }
}
