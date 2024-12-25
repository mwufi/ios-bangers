//
//  chatappApp.swift
//  chatapp
//
//  Created by Zen on 12/22/24.
//

import SwiftUI

@main
struct chatappApp: App {
    @StateObject private var authService = AuthenticationService.shared
    @State private var showLogin = false
    
    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated {
                MainTabView()
            } else {
                SignUpView(showLogin: $showLogin)
                    .sheet(isPresented: $showLogin) {
                        LoginView()
                    }
            }
        }
    }
}
