import SwiftUI

struct SessionCard: View {
    let title: String
    let subtitle: String
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
                .overlay {
                    VStack(alignment: .leading, spacing: 8) {
                        Spacer()
                        Text(title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            colors: [.black.opacity(0.7), .clear],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                }
        }
        .frame(width: 300)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}

#Preview("Default") {
    SessionCard(
        title: "Morning Focus",
        subtitle: "Start your day with intention",
        imageName: "sunrise.fill"
    ) {}
}

#Preview("Different Icons") {
    ScrollView(.horizontal) {
        HStack(spacing: 16) {
            SessionCard(
                title: "Meditation",
                subtitle: "Clear your mind",
                imageName: "moon.stars.fill"
            ) {}
            
            SessionCard(
                title: "Exercise",
                subtitle: "Stay active",
                imageName: "figure.run"
            ) {}
            
            SessionCard(
                title: "Reading",
                subtitle: "Learn something new",
                imageName: "book.fill"
            ) {}
        }
        .padding()
    }
}

#Preview("Dark Mode") {
    SessionCard(
        title: "Night Focus",
        subtitle: "Deep work session",
        imageName: "moon.fill"
    ) {}
    .preferredColorScheme(.dark)
}
