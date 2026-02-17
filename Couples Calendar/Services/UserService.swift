import Foundation
import FirebaseFirestore

/// Service for managing user profiles
final class UserService {
    static let shared = UserService()
    private let firestore = FirestoreService.shared
    private let collectionName = "users"

    private init() {}

    /// Fetch a user profile by ID
    func fetchUser(userId: String) async throws -> UserProfile {
        return try await firestore.getDocument(collection: collectionName, documentID: userId)
    }

    /// Create or update a user profile
    func saveUser(_ user: UserProfile, userId: String) async throws {
        try await firestore.setDocument(collection: collectionName, documentID: userId, data: user, merge: true)
    }

    /// Update user interests
    func updateInterests(userId: String, interests: [String]) async throws {
        try await firestore.updateDocument(
            collection: collectionName,
            documentID: userId,
            fields: ["interests": interests]
        )
    }

    /// Update user location
    func updateLocation(userId: String, location: GeoPoint) async throws {
        try await firestore.updateDocument(
            collection: collectionName,
            documentID: userId,
            fields: ["location": location]
        )
    }
}
