import Foundation
import FirebaseFirestore

// MARK: - Date Template

/// A template defines a reusable date composition pattern.
/// Templates have placeholder tokens that get resolved with real event/venue data.
struct DateTemplate: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var category: String
    var steps: [TemplateStep]
    var conditions: TemplateConditions?
    var costEstimate: CostEstimate
    var dateCoins: Int
    var tags: [String]
    var isActive: Bool
    var createdAt: Timestamp

    var matchesCategory: EventCategory? {
        EventCategory(rawValue: category)
    }
}

// MARK: - Template Step

struct TemplateStep: Codable {
    let order: Int
    let role: String
    let titleTemplate: String
    let descriptionTemplate: String?
    let venueType: String?
    let durationMinutes: Int?
    let isAnchorEvent: Bool

    var stepRole: StepRole? {
        StepRole(rawValue: role)
    }
}

// MARK: - Template Conditions

struct TemplateConditions: Codable {
    var requiresCategory: String?
    var minPrice: Int?
    var timeOfDay: String?
    var dayOfWeek: [String]?
}
