import SwiftUI

struct SignUpView: View {
    @StateObject private var authService = AuthenticationService.shared
    @Environment(\.dismiss) private var dismiss
    @Binding var showLogin: Bool
    
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var signUpMethod: SignUpMethod = .email
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    enum SignUpMethod {
        case email
        case phone
    }
    
    // Array of inspirational messages
    private let inspirationalMessages = [
        "Ready to start your journey?",
        "Your next great conversation awaits!",
        "Join our community of amazing people!",
        "Connect, share, and grow together!",
        "Welcome to something special!"
    ]
    
    init(showLogin: Binding<Bool>? = nil) {
        _showLogin = showLogin ?? .constant(false)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Inspirational message
                    Text(inspirationalMessages.randomElement() ?? "Welcome!")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                        .foregroundColor(.primary)
                    
                    // Sign up method picker
                    Picker("Sign Up Method", selection: $signUpMethod) {
                        Text("Email").tag(SignUpMethod.email)
                        Text("Phone").tag(SignUpMethod.phone)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        // Contact information
                        if signUpMethod == .email {
                            CustomTextField(text: $email, placeholder: "Email", systemImage: "envelope")
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        } else {
                            CustomTextField(text: $phone, placeholder: "Phone Number", systemImage: "phone")
                                .textContentType(.telephoneNumber)
                                .keyboardType(.phonePad)
                        }
                        
                        // Name fields
                        HStack(spacing: 15) {
                            CustomTextField(text: $firstName, placeholder: "First Name", systemImage: "person")
                                .textContentType(.givenName)
                            CustomTextField(text: $lastName, placeholder: "Last Name", systemImage: "person")
                                .textContentType(.familyName)
                        }
                        
                        // Password fields
                        CustomTextField(text: $password, placeholder: "Password", systemImage: "lock", isSecure: true)
                            .textContentType(.newPassword)
                        
                        CustomTextField(text: $confirmPassword, placeholder: "Confirm Password", systemImage: "lock", isSecure: true)
                            .textContentType(.newPassword)
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.callout)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Sign up button
                        Button(action: signUp) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Create Account")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValidForm ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .disabled(!isValidForm || isLoading)
                        
                        // Login link
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.secondary)
                            Button("Log in") {
                                showLogin = true
                            }
                            .foregroundColor(.blue)
                        }
                        .font(.callout)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var isValidForm: Bool {
        let isValidEmail = signUpMethod == .email ? !email.isEmpty : true
        let isValidPhone = signUpMethod == .phone ? !phone.isEmpty : true
        return (isValidEmail || isValidPhone) &&
            !firstName.isEmpty &&
            !lastName.isEmpty &&
            !password.isEmpty &&
            !confirmPassword.isEmpty &&
            password == confirmPassword &&
            password.count >= 6
    }
    
    private func signUp() {
        guard isValidForm else { return }
        
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                if signUpMethod == .email {
                    try await authService.signUp(email: email, password: password)
                } else {
                    try await authService.signUpWithPhone(phone: phone, password: password)
                }
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let systemImage: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .frame(height: 55)
    }
}

#Preview {
    SignUpView()
}
