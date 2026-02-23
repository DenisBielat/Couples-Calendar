import Foundation

// MARK: - Composition Source

enum CompositionSource: String, Codable, CaseIterable {
    case composed    // Auto-generated from template + event
    case community   // Community-submitted full date plan
    case curated     // Simple template, no anchor event
}

// MARK: - Date Composition

struct DateComposition: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let category: EventCategory
    let steps: [DateStep]
    let estimatedCost: CostEstimate
    let dateCoins: Int
    let imageURL: String?
    let tags: [String]
    let source: CompositionSource
    let anchorEventId: String?

    var beforeSteps: [DateStep] {
        steps.filter { $0.role == .before }.sorted { $0.order < $1.order }
    }

    var mainSteps: [DateStep] {
        steps.filter { $0.role == .main }.sorted { $0.order < $1.order }
    }

    var afterSteps: [DateStep] {
        steps.filter { $0.role == .after }.sorted { $0.order < $1.order }
    }

    var totalDuration: String? {
        let totalMinutes = steps.compactMap(\.durationMinutes).reduce(0, +)
        guard totalMinutes > 0 else { return nil }
        let hours = totalMinutes / 60
        let mins = totalMinutes % 60
        if hours > 0 && mins > 0 {
            return "\(hours)h \(mins)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(mins)m"
        }
    }

    var stepCount: Int { steps.count }
}
