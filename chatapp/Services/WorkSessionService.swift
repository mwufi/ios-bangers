import Foundation
import Supabase

class WorkSessionService: ObservableObject {
    private let auth = AuthenticationService.shared
    
    func fetchSessions() async throws -> [WorkSession] {
        return try await auth.supabase
            .from("work_sessions")
            .select("*, project:project_id(*)")
            .execute()
            .value
    }
    
    func createSession(newSession: NewSession) async throws -> WorkSession {
        guard let userId = auth.currentUser?.id else {
            throw AuthError.notAuthenticated
        }
        
        
        let sessions: [WorkSession] = try await auth.supabase
            .from("work_sessions")
            .insert(newSession)
            .select("*, project:project_id(*)")
            .execute()
            .value
            
        guard let session = sessions.first else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create session"])
        }
        return session
    }
    
    func endSession(_ sessionId: Int) async throws {
        let update = SessionUpdate(
            endedAt: ISO8601DateFormatter().string(from: Date()),
            editedDuration: nil
        )
        
        try await auth.supabase
            .from("work_sessions")
            .update(update)
            .eq("id", value: sessionId)
            .execute()
    }
    
    func updateSession(_ sessionId: Int, editedDuration: Int? = nil) async throws {
        let update = SessionUpdate(
            endedAt: nil,
            editedDuration: editedDuration
        )
        
        try await auth.supabase
            .from("work_sessions")
            .update(update)
            .eq("id", value: sessionId)
            .execute()
    }
}
