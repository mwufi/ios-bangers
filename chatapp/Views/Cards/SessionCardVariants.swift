import SwiftUI

// Minimal Session Card
struct MinimalSessionCard: View {
    let title: String
    let duration: TimeInterval
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(.orange)
                    .frame(width: 8, height: 8)
                Text(title)
                    .font(.headline)
            }
            
            Text(duration.formatted() + " minutes")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 200)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// Gradient Session Card
struct GradientSessionCard: View {
    let title: String
    let subtitle: String
    let gradient: LinearGradient
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Button(action: action) {
                Text("Start")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
            }
        }
        .padding()
        .frame(width: 300, height: 200)
        .background(gradient)
        .cornerRadius(16)
    }
}

// Stats Session Card
struct StatsSessionCard: View {
    let title: String
    let sessionsCount: Int
    let totalTime: TimeInterval
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("\(sessionsCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Sessions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading) {
                    Text(totalTime.formatted())
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Minutes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(width: 250)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

#Preview("Minimal") {
    MinimalSessionCard(
        title: "Quick Focus",
        duration: 1800
    ) {}
}

#Preview("Gradient") {
    GradientSessionCard(
        title: "Evening Meditation",
        subtitle: "Clear your mind",
        gradient: LinearGradient(
            colors: [.purple, .blue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    ) {}
}

#Preview("Stats") {
    StatsSessionCard(
        title: "This Week",
        sessionsCount: 12,
        totalTime: 7200
    ) {}
}

#Preview("All Variants") {
    ScrollView {
        VStack(spacing: 20) {
            MinimalSessionCard(
                title: "Quick Focus",
                duration: 1800
            ) {}
            
            GradientSessionCard(
                title: "Evening Meditation",
                subtitle: "Clear your mind",
                gradient: LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ) {}
            
            StatsSessionCard(
                title: "This Week",
                sessionsCount: 12,
                totalTime: 7200
            ) {}
        }
        .padding()
    }
}
