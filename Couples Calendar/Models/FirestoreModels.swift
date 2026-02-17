import Foundation
import FirebaseFirestore

// MARK: - User Profile

struct UserProfile: Codable, Identifiable {
    @DocumentID var id: String?
    var displayName: String
    var characterType: String
    var characterName: String
    var interests: [String]
    var location: GeoPoint?
    var partnerId: String?
    var createdAt: Timestamp

    init(
        id: String? = nil,
        displayName: String = "",
        characterType: String = "bear",
        characterName: String = "",
        interests: [String] = [],
        location: GeoPoint? = nil,
        partnerId: String? = nil,
        createdAt: Timestamp = Timestamp(date: Date())
    ) {
        self.id = id
        self.displayName = displayName
        self.characterType = characterType
        self.characterName = characterName
        self.interests = interests
        self.location = location
        self.partnerId = partnerId
        self.createdAt = createdAt
    }
}

// MARK: - Couple

struct Couple: Codable, Identifiable {
    @DocumentID var id: String?
    var user1Id: String
    var user2Id: String
    var dateCoins: Int
    var dateStreak: Int
    var createdAt: Timestamp

    init(
        id: String? = nil,
        user1Id: String = "",
        user2Id: String = "",
        dateCoins: Int = 0,
        dateStreak: Int = 0,
        createdAt: Timestamp = Timestamp(date: Date())
    ) {
        self.id = id
        self.user1Id = user1Id
        self.user2Id = user2Id
        self.dateCoins = dateCoins
        self.dateStreak = dateStreak
        self.createdAt = createdAt
    }
}

// MARK: - Community Event (Firestore document)

struct CommunityEventDocument: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var organizerName: String
    var organizerEmail: String
    var date: Timestamp
    var time: String
    var location: GeoPoint?
    var locationName: String
    var category: String
    var isVerified: Bool
    var attendeeCount: Int
    var status: String
    var imageURL: String?
    var tags: [String]
    var createdAt: Timestamp

    init(
        id: String? = nil,
        title: String = "",
        description: String = "",
        organizerName: String = "",
        organizerEmail: String = "",
        date: Timestamp = Timestamp(date: Date()),
        time: String = "",
        location: GeoPoint? = nil,
        locationName: String = "",
        category: String = "classes",
        isVerified: Bool = false,
        attendeeCount: Int = 0,
        status: String = "pending",
        imageURL: String? = nil,
        tags: [String] = [],
        createdAt: Timestamp = Timestamp(date: Date())
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.organizerName = organizerName
        self.organizerEmail = organizerEmail
        self.date = date
        self.time = time
        self.location = location
        self.locationName = locationName
        self.category = category
        self.isVerified = isVerified
        self.attendeeCount = attendeeCount
        self.status = status
        self.imageURL = imageURL
        self.tags = tags
        self.createdAt = createdAt
    }

    /// Convert Firestore document to the app's Event model
    func toEvent() -> Event {
        let eventCategory = EventCategory(rawValue: category.capitalized) ?? .classes
        return Event(
            id: id ?? UUID().uuidString,
            title: title,
            venue: locationName,
            date: date.dateValue(),
            time: time,
            price: "Free",
            imageURL: imageURL,
            category: eventCategory,
            source: .community,
            tags: tags,
            description: description,
            organizerName: organizerName,
            attendeeCount: attendeeCount,
            isVerified: isVerified
        )
    }
}

// MARK: - Saved Event

struct SavedEventDocument: Codable, Identifiable {
    @DocumentID var id: String?
    var eventId: String
    var source: String
    var savedAt: Timestamp
    var savedBy: String

    init(
        id: String? = nil,
        eventId: String = "",
        source: String = "community",
        savedAt: Timestamp = Timestamp(date: Date()),
        savedBy: String = ""
    ) {
        self.id = id
        self.eventId = eventId
        self.source = source
        self.savedAt = savedAt
        self.savedBy = savedBy
    }
}
