import Foundation
import FirebaseFirestore

/// Service for saving and unsaving events for a couple
final class SavedEventService {
    static let shared = SavedEventService()
    private let firestore = FirestoreService.shared
    private let parentCollection = "savedEvents"
    private let subcollection = "events"

    private init() {}

    /// Fetch all saved event IDs for a couple
    func fetchSavedEventIDs(coupleId: String) async throws -> Set<String> {
        let documents: [SavedEventDocument] = try await firestore.getSubcollectionDocuments(
            parentCollection: parentCollection,
            parentID: coupleId,
            subcollection: subcollection
        )
        return Set(documents.map { $0.eventId })
    }

    /// Fetch all saved event documents for a couple
    func fetchSavedEvents(coupleId: String) async throws -> [SavedEventDocument] {
        return try await firestore.getSubcollectionDocuments(
            parentCollection: parentCollection,
            parentID: coupleId,
            subcollection: subcollection
        )
    }

    /// Save an event for a couple
    func saveEvent(coupleId: String, eventId: String, source: EventSource, userId: String) async throws {
        let savedEvent = SavedEventDocument(
            eventId: eventId,
            source: source.rawValue,
            savedAt: Timestamp(date: Date()),
            savedBy: userId
        )
        _ = try await firestore.createSubcollectionDocument(
            parentCollection: parentCollection,
            parentID: coupleId,
            subcollection: subcollection,
            data: savedEvent
        )
    }

    /// Unsave an event for a couple
    func unsaveEvent(coupleId: String, eventId: String) async throws {
        // Find the document with matching eventId
        let query = firestore.db
            .collection(parentCollection)
            .document(coupleId)
            .collection(subcollection)
            .whereField("eventId", isEqualTo: eventId)

        let snapshot = try await query.getDocuments()
        for doc in snapshot.documents {
            try await doc.reference.delete()
        }
    }

    /// Check if an event is saved
    func isEventSaved(coupleId: String, eventId: String) async throws -> Bool {
        let query = firestore.db
            .collection(parentCollection)
            .document(coupleId)
            .collection(subcollection)
            .whereField("eventId", isEqualTo: eventId)
            .limit(to: 1)

        let snapshot = try await query.getDocuments()
        return !snapshot.documents.isEmpty
    }
}
