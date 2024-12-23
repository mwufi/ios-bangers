import SwiftUI

// Dog Section
struct Dog: Identifiable {
    let id = UUID()
    let name: String
    let breed: String
    let emoji: String
    let age: Int
    let favoriteActivity: String
    let personality: String
    let funFact: String
    
    static func generateRandomDogs() -> [Dog] {
        let dogBreeds = [
            ("Golden Retriever", "🦮"),
            ("Corgi", "🐕"),
            ("Husky", "🐺"),
            ("Poodle", "🐩"),
            ("Bulldog", "🐶"),
            ("Shiba Inu", "🐕"),
            ("German Shepherd", "🦮"),
            ("Labrador", "🐕"),
            ("Chihuahua", "🐕"),
            ("Dalmatian", "🐕")
        ]
        
        let activities = ["Playing fetch", "Swimming", "Chasing squirrels", "Belly rubs", "Agility training", 
                         "Beach walks", "Dog park adventures", "Tug of war", "Learning tricks", "Napping in sunspots"]
        
        let personalities = ["Playful", "Gentle", "Energetic", "Lazy", "Smart", 
                           "Curious", "Friendly", "Protective", "Silly", "Independent"]
        
        let funFacts = [
            "Can catch treats in mid-air with 100% accuracy",
            "Knows how to open the refrigerator",
            "Loves watching TV, especially dog shows",
            "Has a favorite stuffed toy named Mr. Squeaks",
            "Once won a local dog show",
            "Can sense when it's exactly dinner time",
            "Loves to 'sing' along with sirens",
            "Has a best friend who's a cat",
            "Knows over 20 tricks",
            "Prefers sleeping upside down"
        ]
        
        let names = ["Luna", "Max", "Bella", "Charlie", "Lucy", 
                    "Cooper", "Bailey", "Rocky", "Daisy", "Milo"]
        
        return (0..<10).map { i in
            Dog(
                name: names[i],
                breed: dogBreeds[i].0,
                emoji: dogBreeds[i].1,
                age: Int.random(in: 1...12),
                favoriteActivity: activities[i],
                personality: personalities[i],
                funFact: funFacts[i]
            )
        }
    }
}

struct DogParkView: View {
    let dogs = Dog.generateRandomDogs()
    
    var body: some View {
        List(dogs) { dog in
            NavigationLink(destination: DogProfileView(dog: dog)) {
                Label {
                    VStack(alignment: .leading) {
                        Text(dog.name)
                            .font(.headline)
                        Text(dog.breed)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } icon: {
                    Text(dog.emoji)
                        .font(.title2)
                }
            }
        }
        .navigationTitle("Dog Park")
    }
}

struct DogProfileView: View {
    let dog: Dog
    @State private var isShowingWelcome = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isShowingWelcome {
                    Text(dog.emoji)
                        .font(.system(size: 100))
                        .transition(.scale)
                }
                
                VStack(spacing: 15) {
                    Text(dog.name)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(dog.breed)
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    InfoRow(title: "Age", value: "\(dog.age) years old")
                    InfoRow(title: "Personality", value: dog.personality)
                    InfoRow(title: "Favorite Activity", value: dog.favoriteActivity)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fun Fact:")
                            .font(.headline)
                        Text(dog.funFact)
                            .italic()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()
            }
        }
        .navigationTitle("\(dog.name)'s Profile")
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isShowingWelcome = false
                }
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}