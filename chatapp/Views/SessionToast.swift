import SwiftUI

struct SessionToast: View {
    let session: Session
    let projectName: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Recording: \(projectName)")
                    .font(.headline)
                Text(session.startTime.formatted(date: .omitted, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("Stop")
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .padding()
    }
}
