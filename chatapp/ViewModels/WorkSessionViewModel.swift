import Foundation
import Supabase

@MainActor
class WorkSessionViewModel: ObservableObject {
    @Published var activeSessions: [WorkSession] = []
    @Published var pastSessions: [WorkSession] = []
    @Published var error: String?
    
    private let sessionService = WorkSessionService()
    private var timer: Timer?
    
    init() {
        startTimer()
        Task {
            await fetchSessions()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func fetchSessions() async {
        do {
            let sessions = try await sessionService.fetchSessions()
            
            activeSessions = sessions.filter { $0.isActive }
            pastSessions = sessions.filter { !$0.isActive }
                .sorted { $0.createdAt > $1.createdAt }
            
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func createSession(name: String, category: String? = nil, projectId: Int? = nil, target: Int? = nil) async {
        do {
            _ = try await sessionService.createSession(name: name, category: category, projectId: projectId, target: target)
            await fetchSessions()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func endSession(_ session: WorkSession) async {
        do {
            try await sessionService.endSession(session.id)
            await fetchSessions()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func formatDuration(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
