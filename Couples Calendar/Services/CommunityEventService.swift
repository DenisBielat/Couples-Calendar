import Foundation
import FirebaseFirestore

/// Service for fetching and submitting community events
final class CommunityEventService {
    static let shared = CommunityEventService()
    private let firestore = FirestoreService.shared
    private let collectionName = "communityEvents"

    private init() {}

    /// Fetch all approved community events
    func fetchApprovedEvents() async throws -> [Event] {
        let query = firestore.db
            .collection(collectionName)
            .whereField("status", isEqualTo: "approved")
            .order(by: "date", descending: false)

        let documents: [CommunityEventDocument] = try await firestore.getDocuments(query: query)
        return documents.map { $0.toEvent() }
    }

    /// Fetch community events by category
    func fetchEvents(category: String) async throws -> [Event] {
        let query = firestore.db
            .collection(collectionName)
            .whereField("status", isEqualTo: "approved")
            .whereField("category", isEqualTo: category.lowercased())

        let documents: [CommunityEventDocument] = try await firestore.getDocuments(query: query)
        return documents.map { $0.toEvent() }
    }

    /// Submit a new community event (starts as pending)
    func submitEvent(_ event: CommunityEventDocument) async throws -> String {
        var newEvent = event
        newEvent.status = "pending"
        newEvent.createdAt = Timestamp(date: Date())
        return try await firestore.createDocument(collection: collectionName, data: newEvent)
    }

    /// Seed sample community events for testing
    func seedSampleEvents() async throws {
        let snapshot = try await firestore.db
            .collection(collectionName)
            .limit(to: 1)
            .getDocuments()

        // Only seed if collection is empty
        guard snapshot.documents.isEmpty else { return }

        let sampleEvents: [CommunityEventDocument] = [
            CommunityEventDocument(
                title: "Couples Paint & Sip",
                description: "Paint a masterpiece together while enjoying wine and snacks. No experience needed!",
                organizerName: "Art Bar Studio",
                organizerEmail: "info@artbarstudio.com",
                date: Timestamp(date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!),
                time: "6:30 PM",
                locationName: "Art Bar Studio",
                category: "classes",
                isVerified: true,
                attendeeCount: 24,
                status: "approved",
                tags: ["art", "wine", "social"]
            ),
            CommunityEventDocument(
                title: "Salsa Dancing for Beginners",
                description: "Learn the basics of salsa dancing with your partner. Fun, energetic, and perfect for date night.",
                organizerName: "Dance Central Academy",
                organizerEmail: "hello@dancecentral.com",
                date: Timestamp(date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
                time: "7:00 PM",
                locationName: "Dance Central",
                category: "classes",
                isVerified: true,
                attendeeCount: 18,
                status: "approved",
                tags: ["dance", "active", "fun"]
            ),
            CommunityEventDocument(
                title: "Couples Cooking: Italian Night",
                description: "Cook a full Italian dinner together with a professional chef guiding you step by step.",
                organizerName: "Chef Marco",
                organizerEmail: "marco@chefskitchen.com",
                date: Timestamp(date: Calendar.current.date(byAdding: .day, value: 6, to: Date())!),
                time: "6:00 PM",
                locationName: "Chef's Kitchen",
                category: "food",
                isVerified: false,
                attendeeCount: 12,
                status: "approved",
                tags: ["cooking", "italian", "hands-on"]
            ),
            CommunityEventDocument(
                title: "Outdoor Movie Night",
                description: "Bring a blanket and snuggle up for a classic movie under the stars. Popcorn provided!",
                organizerName: "Parks & Rec Dept",
                organizerEmail: "events@parksrec.com",
                date: Timestamp(date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!),
                time: "8:00 PM",
                locationName: "Riverside Park",
                category: "outdoors",
                isVerified: true,
                attendeeCount: 56,
                status: "approved",
                tags: ["movie", "free", "outdoor"]
            )
        ]

        for event in sampleEvents {
            _ = try await firestore.createDocument(collection: collectionName, data: event)
        }
    }
}
