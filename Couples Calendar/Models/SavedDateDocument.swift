import Foundation
import FirebaseFirestore

/// Saved date composition for a couple (Firestore document)
struct SavedDateDocument: Codable, Identifiable {
    @DocumentID var id: String?
    var compositionId: String
    var compositionSnapshot: DateComposition
    var savedAt: Timestamp
    var savedBy: String
    var status: String
    var plannedDate: Timestamp?
    var notes: String?

    init(
        id: String? = nil,
        compositionId: String = "",
        compositionSnapshot: DateComposition,
        savedAt: Timestamp = Timestamp(date: Date()),
        savedBy: String = "",
        status: String = "saved",
        plannedDate: Timestamp? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.compositionId = compositionId
        self.compositionSnapshot = compositionSnapshot
        self.savedAt = savedAt
        self.savedBy = savedBy
        self.status = status
        self.plannedDate = plannedDate
        self.notes = notes
    }
}
