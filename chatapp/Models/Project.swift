import Foundation
import SwiftUI

struct Project: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String?
    let headerImg: String?
    let isPublic: Bool
    let createdAt: Date
    let createdBy: UUID
    let color: ProjectColor?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case headerImg = "header_img"
        case isPublic = "is_public"
        case createdAt = "created_at"
        case createdBy = "created_by"
        case color = "color"
    }
    
    static let defaultColors = [
        "#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4", "#FFEEAD",
        "#D4A5A5", "#9B59B6", "#3498DB", "#E67E22", "#1ABC9C"
    ]
    
    static func randomColor() -> ProjectColor {
        ProjectColor(hex: defaultColors.randomElement() ?? "#FF6B6B")
    }
}
