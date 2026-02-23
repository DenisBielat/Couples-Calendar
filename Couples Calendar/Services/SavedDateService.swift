import Foundation
import FirebaseFirestore

final class SavedDateService {
    static let shared = SavedDateService()
    private let firestore = FirestoreService.shared
    private let parentCollection = "couples"
    private let subcollection = "savedDates"

    private init() {}

    func fetchSavedDates(coupleId: String) async throws -> [SavedDateDocument] {
        return try await firestore.getSubcollectionDocuments(
            parentCollection: parentCollection,
            parentID: coupleId,
            subcollection: subcollection
        )
    }

    func fetchSavedDateIDs(coupleId: String) async throws -> Set<String> {
        let docs = try await fetchSavedDates(coupleId: coupleId)
        return Set(docs.map { $0.compositionId })
    }

    func saveDate(coupleId: String, composition: DateComposition, userId: String) async throws {
        let doc = SavedDateDocument(
            compositionId: composition.id,
            compositionSnapshot: composition,
            savedBy: userId
        )
        _ = try await firestore.createSubcollectionDocument(
            parentCollection: parentCollection,
            parentID: coupleId,
            subcollection: subcollection,
            data: doc
        )
    }

    func unsaveDate(coupleId: String, compositionId: String) async throws {
        let query = firestore.db
            .collection(parentCollection)
            .document(coupleId)
            .collection(subcollection)
            .whereField("compositionId", isEqualTo: compositionId)

        let snapshot = try await query.getDocuments()
        for doc in snapshot.documents {
            try await doc.reference.delete()
        }
    }
}
