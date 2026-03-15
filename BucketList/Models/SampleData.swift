import Foundation

struct SampleData {
    static let friends: [(name: String, username: String, color: String)] = [
        ("Alex Johnson", "alexj", "FF6B6B"),
        ("Sarah Chen", "sarahc", "4ECDC4"),
        ("Mike Rivera", "miker", "FFE66D"),
        ("Priya Patel", "priyap", "A78BFA"),
    ]

    static let sharedItems: [(title: String, description: String, category: ItemCategory, friend: String, lat: Double?, lon: Double?, address: String?)] = [
        ("Visit the Grand Canyon", "One of the most breathtaking natural wonders", .place, "Alex Johnson", 36.1069, -112.1129, "Grand Canyon, AZ, USA"),
        ("Try authentic ramen in Tokyo", "Visit Ichiran or a local ramen shop", .food, "Sarah Chen", 35.6762, 139.6503, "Tokyo, Japan"),
        ("Northern Lights in Iceland", "Best seen between September and March", .adventure, "Alex Johnson", 64.1466, -21.9426, "Reykjavik, Iceland"),
        ("Learn to surf in Bali", "Kuta beach is great for beginners", .fitness, "Mike Rivera", -8.7181, 115.1686, "Kuta, Bali, Indonesia"),
        ("Attend La Tomatina Festival", "The world's biggest tomato fight in Spain", .experience, "Priya Patel", 39.4925, -0.5965, "Bunol, Valencia, Spain"),
    ]

    static func populateSampleFriends(context: Any) {
        // This is used by the preview/demo mode
    }
}
