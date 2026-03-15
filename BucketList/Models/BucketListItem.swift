import Foundation
import SwiftData
import CoreLocation

enum ItemCategory: String, Codable, CaseIterable, Identifiable {
    case place = "Place to Visit"
    case experience = "Experience"
    case adventure = "Adventure"
    case food = "Food & Dining"
    case travel = "Travel"
    case learning = "Learning"
    case fitness = "Fitness & Sports"
    case creative = "Creative"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .place: return "mappin.circle.fill"
        case .experience: return "star.circle.fill"
        case .adventure: return "figure.hiking"
        case .food: return "fork.knife.circle.fill"
        case .travel: return "airplane.circle.fill"
        case .learning: return "book.circle.fill"
        case .fitness: return "figure.run.circle.fill"
        case .creative: return "paintbrush.fill"
        case .other: return "circle.fill"
        }
    }
}

@Model
final class BucketListItem {
    var id: UUID
    var title: String
    var itemDescription: String
    var category: ItemCategory
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var isCompleted: Bool
    var completedDate: Date?
    var createdDate: Date
    var sharedByFriend: String?
    var isSharedWithFriends: Bool
    var notes: String

    init(
        title: String,
        itemDescription: String = "",
        category: ItemCategory = .other,
        latitude: Double? = nil,
        longitude: Double? = nil,
        address: String? = nil,
        sharedByFriend: String? = nil,
        isSharedWithFriends: Bool = false,
        notes: String = ""
    ) {
        self.id = UUID()
        self.title = title
        self.itemDescription = itemDescription
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.isCompleted = false
        self.completedDate = nil
        self.createdDate = Date()
        self.sharedByFriend = sharedByFriend
        self.isSharedWithFriends = isSharedWithFriends
        self.notes = notes
    }

    var isMyItem: Bool {
        sharedByFriend == nil
    }

    var hasLocation: Bool {
        latitude != nil && longitude != nil
    }

    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
