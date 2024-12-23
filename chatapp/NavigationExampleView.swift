import SwiftUI

struct NavigationExampleView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("🐕 Dog Park") {
                    DogParkView()
                }
                NavigationLink("🎮 Gaming World") {
                    GamingWorldView()
                }
                NavigationLink("🍔 Food Adventures") {
                    FoodAdventuresView()
                }
                NavigationLink("🎨 Art Gallery") {
                    ArtGalleryView()
                }
                NavigationLink("🎵 Music Library") {
                    MusicLibraryView()
                }
            }
            .navigationTitle("Navigation Demo")
        }
    }
}

// Gaming Section
struct GameCategory: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let description: String
}

struct GamingWorldView: View {
    @State private var selectedCategory: GameCategory?
    
    let categories = [
        GameCategory(name: "Board Games", emoji: "🎲", description: "Classic tabletop entertainment"),
        GameCategory(name: "Video Games", emoji: "🕹️", description: "Digital interactive experiences"),
        GameCategory(name: "Card Games", emoji: "🃏", description: "Strategic card-based fun"),
        GameCategory(name: "Sports Games", emoji: "⚽️", description: "Athletic competitions")
    ]
    
    var body: some View {
        List(categories) { category in
            NavigationLink(destination: GameDetailView(category: category)) {
                Label {
                    VStack(alignment: .leading) {
                        Text(category.name)
                            .font(.headline)
                        Text(category.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } icon: {
                    Text(category.emoji)
                        .font(.title2)
                }
            }
        }
        .navigationTitle("Gaming World")
    }
}

struct GameDetailView: View {
    let category: GameCategory
    @State private var showingWelcome = true
    
    var body: some View {
        VStack {
            if showingWelcome {
                VStack {
                    Text(category.emoji)
                        .font(.system(size: 60))
                    Text("Welcome to \(category.name)!")
                        .font(.title)
                    Text(category.description)
                        .foregroundColor(.gray)
                }
                .padding()
                .transition(.scale.combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showingWelcome = false
                        }
                    }
                }
            }
            
            List {
                switch category.name {
                case "Board Games":
                    NavigationLink("Chess ♟️") {
                        Text("A strategic board game for two players")
                    }
                    NavigationLink("Monopoly 💰") {
                        Text("The classic property trading game")
                    }
                case "Video Games":
                    NavigationLink("Racing 🏎️") {
                        Text("Need for Speed, Mario Kart")
                    }
                    NavigationLink("Adventure 🗺️") {
                        Text("Zelda, Uncharted")
                    }
                case "Card Games":
                    NavigationLink("Poker ♠️") {
                        Text("The popular casino card game")
                    }
                    NavigationLink("Uno 🎴") {
                        Text("The family-friendly card game")
                    }
                default:
                    NavigationLink("FIFA ⚽️") {
                        Text("Virtual soccer experience")
                    }
                    NavigationLink("NBA 2K 🏀") {
                        Text("Professional basketball simulation")
                    }
                }
            }
        }
        .navigationTitle(category.name)
    }
}

// Food Section
struct FoodAdventuresView: View {
    var body: some View {
        List {
            NavigationLink("🍕 Italian Cuisine") {
                List {
                    NavigationLink("Pizza Types") {
                        Text("Margherita, Pepperoni, Hawaiian")
                    }
                    NavigationLink("Pasta Varieties") {
                        Text("Spaghetti, Penne, Fettuccine")
                    }
                }
                .navigationTitle("Italian Cuisine")
            }
            NavigationLink("🍱 Asian Fusion") {
                Text("Sushi, Dim Sum, Pad Thai")
                    .navigationTitle("Asian Fusion")
            }
        }
        .navigationTitle("Food Adventures")
    }
}

// Art Section
struct ArtGalleryView: View {
    var body: some View {
        List {
            NavigationLink("🖼️ Classical Art") {
                List {
                    NavigationLink("Renaissance") {
                        Text("Mona Lisa, The Birth of Venus")
                    }
                    NavigationLink("Baroque") {
                        Text("The Night Watch, The Return of the Prodigal Son")
                    }
                }
                .navigationTitle("Classical Art")
            }
            NavigationLink("🎨 Modern Art") {
                Text("Abstract, Pop Art, Minimalism")
                    .navigationTitle("Modern Art")
            }
        }
        .navigationTitle("Art Gallery")
    }
}

// Music Section
struct MusicLibraryView: View {
    var body: some View {
        List {
            NavigationLink("🎸 Rock") {
                List {
                    NavigationLink("Classic Rock") {
                        Text("Led Zeppelin, Pink Floyd")
                    }
                    NavigationLink("Modern Rock") {
                        Text("Foo Fighters, Muse")
                    }
                }
                .navigationTitle("Rock Music")
            }
            NavigationLink("🎹 Classical") {
                Text("Mozart, Beethoven, Bach")
                    .navigationTitle("Classical Music")
            }
        }
        .navigationTitle("Music Library")
    }
}

#Preview {
    NavigationExampleView()
}
