import Foundation
import FirebaseFirestore

/// Generic Firestore CRUD operations
final class FirestoreService {
    static let shared = FirestoreService()
    let db = Firestore.firestore()

    private init() {}

    // MARK: - Generic CRUD

    /// Fetch a single document by ID
    func getDocument<T: Decodable>(collection: String, documentID: String) async throws -> T {
        let snapshot = try await db.collection(collection).document(documentID).getDocument()
        return try snapshot.data(as: T.self)
    }

    /// Fetch all documents in a collection
    func getDocuments<T: Decodable>(collection: String) async throws -> [T] {
        let snapshot = try await db.collection(collection).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: T.self) }
    }

    /// Fetch documents with a query
    func getDocuments<T: Decodable>(query: Query) async throws -> [T] {
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: T.self) }
    }

    /// Create a document with auto-generated ID
    @discardableResult
    func createDocument<T: Encodable>(collection: String, data: T) async throws -> String {
        let ref = try db.collection(collection).addDocument(from: data)
        return ref.documentID
    }

    /// Set a document with a specific ID
    func setDocument<T: Encodable>(collection: String, documentID: String, data: T, merge: Bool = false) async throws {
        try db.collection(collection).document(documentID).setData(from: data, merge: merge)
    }

    /// Update specific fields on a document
    func updateDocument(collection: String, documentID: String, fields: [String: Any]) async throws {
        try await db.collection(collection).document(documentID).updateData(fields)
    }

    /// Delete a document
    func deleteDocument(collection: String, documentID: String) async throws {
        try await db.collection(collection).document(documentID).delete()
    }

    // MARK: - Subcollection helpers

    /// Fetch documents from a subcollection
    func getSubcollectionDocuments<T: Decodable>(
        parentCollection: String,
        parentID: String,
        subcollection: String
    ) async throws -> [T] {
        let snapshot = try await db
            .collection(parentCollection)
            .document(parentID)
            .collection(subcollection)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: T.self) }
    }

    /// Create a document in a subcollection
    @discardableResult
    func createSubcollectionDocument<T: Encodable>(
        parentCollection: String,
        parentID: String,
        subcollection: String,
        data: T
    ) async throws -> String {
        let ref = try db
            .collection(parentCollection)
            .document(parentID)
            .collection(subcollection)
            .addDocument(from: data)
        return ref.documentID
    }

    /// Delete a document from a subcollection
    func deleteSubcollectionDocument(
        parentCollection: String,
        parentID: String,
        subcollection: String,
        documentID: String
    ) async throws {
        try await db
            .collection(parentCollection)
            .document(parentID)
            .collection(subcollection)
            .document(documentID)
            .delete()
    }
}
