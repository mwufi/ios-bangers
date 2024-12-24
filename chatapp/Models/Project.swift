import Foundation

struct Project: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String?
    let headerImg: String?
    let isPublic: Bool
    let createdAt: Date
    let createdBy: UUID
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case headerImg = "header_img"
        case isPublic = "is_public"
        case createdAt = "created_at"
        case createdBy = "created_by"
    }
}

struct Session: Identifiable {
    let id = UUID()
    let startTime: Date
    var endTime: Date?
}
