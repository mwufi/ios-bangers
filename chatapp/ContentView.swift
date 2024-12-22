//
//  ContentView.swift
//  chatapp
//
//  Created by Zen on 12/22/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ProjectViewModel()
    @State private var selectedTab = "Your Day"
    @State private var selectedProject: Project?
    @State private var activeSession: Session?
    
    let tabs = ["Your Day", "Universe", "Friends", "Popular"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Text("FLOW")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "waveform.path")
                            .font(.title2)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "bag")
                            .font(.title2)
                    }
                }
                .padding()
                
                // Tab Menu
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(tabs, id: \.self) { tab in
                            VStack {
                                Text(tab)
                                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                                
                                // Indicator
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(selectedTab == tab ? .blue : .clear)
                            }
                            .onTapGesture {
                                withAnimation { selectedTab = tab }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Greeting
                        Text("Good morning, User")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        // What's New Section
                        Text("What's new")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        // Horizontal Scrolling Cards
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(0..<5) { i in
                                    SessionCard(
                                        title: "Morning Focus",
                                        subtitle: "Start your day with intention",
                                        imageName: "sunrise.fill"
                                    ) {}
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Projects Section
                        Text("Your Projects")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            ForEach(viewModel.projects) { project in
                                ProjectCard(project: project) {
                                    selectedProject = project
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                
                // Bottom Tab Bar
                HStack {
                    Spacer()
                    ForEach(["house.fill", "clock", "person.2.fill", "gearshape.fill"], id: \.self) { icon in
                        Button(action: {}) {
                            Image(systemName: icon)
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                }
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }
            .background(Color(.systemBackground))
            
            // Active Session Toast
            if let session = activeSession {
                SessionToast(session: session, projectName: "Project Name")
                    .transition(.move(edge: .bottom))
            }
        }
        .sheet(item: $selectedProject) { project in
            ProjectDetailView(project: project, activeSession: $activeSession)
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
