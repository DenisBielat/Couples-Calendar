import Foundation

// MARK: - Date Filter

enum DateFilter: String, CaseIterable, Identifiable {
    case anytime = "Anytime"
    case today = "Today"
    case thisWeek = "This Week"
    case thisWeekend = "Weekend"
    case thisMonth = "This Month"
    case custom = "Pick Dates"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .anytime: return "calendar"
        case .today: return "sun.max"
        case .thisWeek: return "calendar.badge.clock"
        case .thisWeekend: return "sparkles"
        case .thisMonth: return "calendar.badge.plus"
        case .custom: return "calendar.badge.exclamationmark"
        }
    }

    /// Returns the date range for this filter, or nil for "anytime" / "custom"
    var dateRange: (start: Date, end: Date)? {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)

        switch self {
        case .anytime:
            return nil
        case .today:
            let endOfToday = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
            return (startOfToday, endOfToday)
        case .thisWeek:
            // From today through end of this week (Sunday)
            let weekday = calendar.component(.weekday, from: now)
            let daysUntilEndOfWeek = 8 - weekday // Sunday = 1, so we go to next Sunday
            let endOfWeek = calendar.date(byAdding: .day, value: daysUntilEndOfWeek, to: startOfToday)!
            return (startOfToday, endOfWeek)
        case .thisWeekend:
            // Saturday and Sunday of this week
            let weekday = calendar.component(.weekday, from: now)
            let daysUntilSaturday = (7 - weekday) % 7 // Saturday = 7
            let saturday = calendar.date(byAdding: .day, value: weekday == 7 ? 0 : daysUntilSaturday, to: startOfToday)!
            let monday = calendar.date(byAdding: .day, value: 2, to: saturday)!
            // If it's already the weekend, start from today
            let start = now >= saturday ? startOfToday : saturday
            return (start, monday)
        case .thisMonth:
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: 0), to: calendar.startOfDay(for: calendar.date(from: calendar.dateComponents([.year, .month], from: now))!))!
            let dayAfterMonth = calendar.date(byAdding: .day, value: 1, to: endOfMonth)!
            return (startOfToday, dayAfterMonth)
        case .custom:
            return nil
        }
    }
}

// MARK: - Event Category

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

    // Consolidated event support — when the same show has multiple dates
    var additionalDates: [Date]
    var totalShowCount: Int

    init(
        id: String,
        title: String,
        venue: String,
        date: Date,
        time: String,
        price: String,
        imageURL: String?,
        category: EventCategory,
        source: EventSource,
        tags: [String],
        description: String,
        organizerName: String?,
        attendeeCount: Int?,
        isVerified: Bool,
        additionalDates: [Date] = [],
        totalShowCount: Int = 1
    ) {
        self.id = id
        self.title = title
        self.venue = venue
        self.date = date
        self.time = time
        self.price = price
        self.imageURL = imageURL
        self.category = category
        self.source = source
        self.tags = tags
        self.description = description
        self.organizerName = organizerName
        self.attendeeCount = attendeeCount
        self.isVerified = isVerified
        self.additionalDates = additionalDates
        self.totalShowCount = totalShowCount
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        if totalShowCount > 1 {
            let endDate = additionalDates.last ?? date
            let endStr = formatter.string(from: endDate)
            let startStr = formatter.string(from: date)
            if startStr == endStr {
                return startStr
            }
            return "\(startStr) – \(endStr)"
        }
        return formatter.string(from: date)
    }

    var showCountLabel: String? {
        totalShowCount > 1 ? "\(totalShowCount) shows" : nil
    }

    var isTonight: Bool {
        let allDates = [date] + additionalDates
        return allDates.contains { Calendar.current.isDateInToday($0) }
    }

    /// All dates for this event (primary + additional consolidated dates)
    var allDates: [Date] {
        ([date] + additionalDates).sorted()
    }

    /// Check if this event has any date within the given range
    func hasDateInRange(start: Date, end: Date) -> Bool {
        return allDates.contains { $0 >= start && $0 < end }
    }

    /// The deduplication key — events with the same key are the same show
    var deduplicationKey: String {
        // Normalize: lowercase, trim whitespace, combine with venue
        let normalizedTitle = title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedVenue = venue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return "\(normalizedTitle)|\(normalizedVenue)"
    }

    /// Merge another event (same show, different date) into this one
    func mergedWith(_ other: Event) -> Event {
        var allDates = additionalDates
        allDates.append(other.date)
        allDates.append(contentsOf: other.additionalDates)
        // Remove dupes and sort
        let uniqueDates = Array(Set(allDates)).sorted()

        return Event(
            id: id,
            title: title,
            venue: venue,
            date: min(date, other.date),
            time: time,
            price: price,
            imageURL: imageURL ?? other.imageURL,
            category: category,
            source: source,
            tags: tags,
            description: description.isEmpty ? other.description : description,
            organizerName: organizerName,
            attendeeCount: attendeeCount,
            isVerified: isVerified,
            additionalDates: uniqueDates,
            totalShowCount: totalShowCount + other.totalShowCount
        )
    }
}

// MARK: - Deduplication

extension Array where Element == Event {
    /// Consolidate duplicate events (same title + venue) into single entries with multiple dates
    func deduplicated() -> [Event] {
        var seen: [String: Event] = [:]
        var order: [String] = []

        for event in self {
            let key = event.deduplicationKey
            if let existing = seen[key] {
                seen[key] = existing.mergedWith(event)
            } else {
                seen[key] = event
                order.append(key)
            }
        }

        return order.compactMap { seen[$0] }
    }
}
