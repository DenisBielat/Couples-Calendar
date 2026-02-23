import Foundation

// MARK: - Step Role

enum StepRole: String, Codable, CaseIterable {
    case before
    case main
    case after

    var label: String {
        switch self {
        case .before: return "Before"
        case .main: return "Main Event"
        case .after: return "After"
        }
    }

    var icon: String {
        switch self {
        case .before: return "sunrise"
        case .main: return "star.fill"
        case .after: return "moon.stars"
        }
    }
}

// MARK: - Date Step

struct DateStep: Identifiable, Codable {
    let id: String
    let order: Int
    let role: StepRole
    let title: String
    let description: String?
    let venueName: String?
    let venueAddress: String?
    let time: String?
    let durationMinutes: Int?
    let externalURL: String?
    let placeId: String?
    let imageURL: String?

    var formattedDuration: String? {
        guard let mins = durationMinutes else { return nil }
        if mins >= 60 {
            let h = mins / 60
            let m = mins % 60
            return m > 0 ? "\(h)h \(m)m" : "\(h)h"
        }
        return "\(mins) min"
    }
}
