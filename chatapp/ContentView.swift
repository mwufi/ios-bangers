//
//  ContentView.swift
//  chatapp
//
//  Created by Zen on 12/22/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ProjectViewModel()
    
    var body: some View {
        TabView {
            ProjectsView(viewModel: viewModel)
                .tabItem {
                    Label("Projects", systemImage: "list.bullet")
                }
            
            Text("Sessions")
                .tabItem {
                    Label("Sessions", systemImage: "clock")
                }
            
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct ProjectsView: View {
    @ObservedObject var viewModel: ProjectViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Your Projects")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top)
                
                VStack(spacing: 16) {
                    ForEach(viewModel.projects) { project in
                        ProjectCard(project: project) {
                            viewModel.startNewSession(for: project)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    ContentView()
}
