import SwiftUI
import PhotosUI
import Supabase
import Storage

struct NewProjectView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var projectService = ProjectService()
    @State private var name = ""
    @State private var description = ""
    @State private var isPublic = true
    @State private var isOpen = true
    @State private var selectedItem: PhotosPickerItem?
    @State private var headerImg: String?
    @State private var isLoading = false
    @State private var isUploading = false
    private let auth = AuthenticationService.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Project Name", text: $name)
                    TextField("Description (optional)", text: $description)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        if let headerImg = headerImg {
                            AsyncImage(url: URL(string: headerImg)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        
                        if isUploading {
                            HStack {
                                ProgressView()
                                    .padding(.trailing, 8)
                                Text("Uploading image...")
                            }
                        } else {
                            PhotosPicker(selection: $selectedItem,
                                       matching: .images) {
                                Label(headerImg == nil ? "Add Header Image" : "Change Header Image",
                                      systemImage: "photo")
                            }
                        }
                    }
                }
                
                Section {
                    Toggle("Public Project", isOn: $isPublic)
                    Toggle("Open Project", isOn: $isOpen)
                }
            }
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        Task {
                            await createProject()
                        }
                    }
                    .disabled(name.isEmpty || isLoading || isUploading)
                }
            }
            .onChange(of: selectedItem) { newItem in
                guard let item = newItem else { return }
                Task {
                    isUploading = true
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        do {
                            let fileName = "project-headers/\(UUID().uuidString.lowercased()).png"
                            
                            try await auth.supabase.storage
                                .from("project-images")
                                .upload(
                                    path: fileName,
                                    file: data,
                                    options: FileOptions(
                                        cacheControl: "3600",
                                        contentType: "image/png",
                                        upsert: false
                                    )
                                )
                            
                            let publicURL = try await auth.supabase.storage
                                .from("project-images")
                                .getPublicURL(path: fileName)
                            
                            headerImg = publicURL.absoluteString
                        } catch {
                            print("Error uploading image: \(error)")
                        }
                    }
                    isUploading = false
                    selectedItem = nil
                }
            }
        }
    }
    
    private func createProject() async {
        isLoading = true
        do {
            let project = try await projectService.createProject(
                name: name,
                description: description.isEmpty ? nil : description,
                headerImg: headerImg,
                isPublic: isPublic,
                isOpen: isOpen
            )
            dismiss()
        } catch {
            print("Error creating project: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    NewProjectView()
}
