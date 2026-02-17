import Foundation

enum EventCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case concerts = "Concerts"
    case comedy = "Comedy"
    case outdoors = "Outdoors"
    case food = "Food"
    case theater = "Theater"
    case classes = "Classes"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .all: return "sparkles"
        case .concerts: return "music.note"
        case .comedy: return "face.smiling"
        case .outdoors: return "leaf"
        case .food: return "fork.knife"
        case .theater: return "theatermasks"
        case .classes: return "paintpalette"
        }
    }
}

enum EventSource: String, Codable {
    case api
    case community
    case curated
}

struct Event: Identifiable {
    let id: String
    let title: String
    let venue: String
    let date: Date
    let time: String
    let price: String
    let imageURL: String?
    let category: EventCategory
    let source: EventSource
    let tags: [String]
    let description: String
    let organizerName: String?
    let attendeeCount: Int?
    let isVerified: Bool

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }

    var isTonight: Bool {
        Calendar.current.isDateInToday(date)
    }
}
