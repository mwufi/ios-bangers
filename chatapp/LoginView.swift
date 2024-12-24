import SwiftUI

struct LoginView: View {
    @StateObject private var authService = AuthenticationService.shared
    @State private var email = ""
    @State private var password = ""
    @State private var phone = ""
    @State private var isShowingOTPField = false
    @State private var otpCode = ""
    @State private var loginMethod: LoginMethod = .email
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    enum LoginMethod {
        case email
        case phone
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Login Method Picker
                Picker("Login Method", selection: $loginMethod) {
                    Text("Email").tag(LoginMethod.email)
                    Text("Phone").tag(LoginMethod.phone)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if loginMethod == .email {
                    // Email login fields
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                } else {
                    // Phone login fields
                    TextField("Phone Number", text: $phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                }
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if isShowingOTPField {
                    TextField("OTP Code", text: $otpCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: {
                    Task {
                        await login()
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text(isShowingOTPField ? "Verify OTP" : "Login")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Login")
        }
    }
    
    private func login() async {
        isLoading = true
        errorMessage = ""
        
        do {
            if isShowingOTPField {
                try await authService.verifyOTP(phone: phone, token: otpCode)
            } else {
                if loginMethod == .email {
                    try await authService.signIn(email: email, password: password)
                } else {
                    try await authService.signInWithPhone(phone: phone, password: password)
                    isShowingOTPField = true
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

#Preview {
    LoginView()
}
