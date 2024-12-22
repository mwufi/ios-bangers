import Foundation

struct Project: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var sessions: [Session] = []
}

struct Session: Identifiable {
    let id = UUID()
    let startTime: Date
    var endTime: Date?
}
