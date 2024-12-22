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

#Preview("Active Session") {
    VStack {
        Spacer()
        SessionToast(
            session: Session(startTime: Date()),
            projectName: "Morning Focus"
        )
    }
}

#Preview("Long Session") {
    VStack {
        Spacer()
        SessionToast(
            session: Session(
                startTime: Date().addingTimeInterval(-3600)
            ),
            projectName: "Deep Work"
        )
    }
}

#Preview("Dark Mode") {
    VStack {
        Spacer()
        SessionToast(
            session: Session(startTime: Date()),
            projectName: "Night Focus"
        )
    }
    .preferredColorScheme(.dark)
}
