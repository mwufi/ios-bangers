import Foundation
import Supabase

enum AuthError: Error {
    case notAuthenticated
}

class AuthenticationService: ObservableObject {
    static let shared = AuthenticationService()
    private(set) var supabase: SupabaseClient
    
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    private init() {
        // Replace these with your actual Supabase credentials
        guard let supabaseURL = URL(string: "https://ynxmunrlesicnfibjctb.supabase.co") else {
            fatalError("Invalid Supabase URL")
        }
        self.supabase = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlueG11bnJsZXNpY25maWJqY3RiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ1ODE1MDYsImV4cCI6MjA1MDE1NzUwNn0.OHrfhWjD1fbNlT7E1GjWgtVATJl-_y1WgcjrrYfWQTA")
    }
    
    func signIn(email: String, password: String) async throws {
        let session = try await supabase.auth.signIn(email: email, password: password)
        DispatchQueue.main.async {
            self.currentUser = session.user
            self.isAuthenticated = true
        }
    }
    
    func signInWithPhone(phone: String, password: String) async throws {
        let session = try await supabase.auth.signIn(phone: phone, password: password)
        DispatchQueue.main.async {
            self.currentUser = session.user
            self.isAuthenticated = true
        }
    }
    
    func verifyOTP(phone: String, token: String) async throws {
        try await supabase.auth.verifyOTP(phone: phone, token: token, type: .sms)
        // After verification, you might want to check the session
        if let session = try? await supabase.auth.session {
            DispatchQueue.main.async {
                self.currentUser = session.user
                self.isAuthenticated = true
            }
        }
    }
    
    func signUp(email: String, password: String) async throws {
        let session = try await supabase.auth.signUp(email: email, password: password)
        DispatchQueue.main.async {
            self.currentUser = session.user
            self.isAuthenticated = true
        }
    }
    
    func signOut() async throws {
        try await supabase.auth.signOut()
        DispatchQueue.main.async {
            self.currentUser = nil
            self.isAuthenticated = false
        }
    }
}
