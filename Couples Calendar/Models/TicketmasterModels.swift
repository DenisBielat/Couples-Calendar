import Foundation

// MARK: - Ticketmaster API Response Models

struct TicketmasterResponse: Decodable {
    let embedded: TicketmasterEmbedded?
    let page: TicketmasterPage?

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case page
    }
}

struct TicketmasterEmbedded: Decodable {
    let events: [TicketmasterEvent]?
}

struct TicketmasterPage: Decodable {
    let size: Int?
    let totalElements: Int?
    let totalPages: Int?
    let number: Int?
}

struct TicketmasterEvent: Decodable, Identifiable {
    let id: String
    let name: String
    let url: String?
    let dates: TicketmasterDates?
    let classifications: [TicketmasterClassification]?
    let priceRanges: [TicketmasterPriceRange]?
    let images: [TicketmasterImage]?
    let embedded: TicketmasterEventVenues?

    enum CodingKeys: String, CodingKey {
        case id, name, url, dates, classifications, priceRanges, images
        case embedded = "_embedded"
    }

    /// Convert to the app's Event model
    func toEvent() -> Event {
        let eventDate = dates?.start?.dateTime.flatMap { ISO8601DateFormatter().date(from: $0) } ?? Date()
        let timeString = dates?.start?.localTime ?? "TBA"
        let formattedTime = formatTime(timeString)
        let venueName = embedded?.venues?.first?.name ?? "TBA"
        let category = mapCategory()
        let priceString = formatPrice()
        let imageURL = bestImage()

        return Event(
            id: "tm_\(id)",
            title: name,
            venue: venueName,
            date: eventDate,
            time: formattedTime,
            price: priceString,
            imageURL: imageURL,
            category: category,
            source: .api,
            tags: classifications?.first?.genre?.name.map { [$0.lowercased()] } ?? [],
            description: "",
            organizerName: nil,
            attendeeCount: nil,
            isVerified: false
        )
    }

    private func mapCategory() -> EventCategory {
        guard let segment = classifications?.first?.segment?.name?.lowercased() else { return .all }
        guard let genre = classifications?.first?.genre?.name?.lowercased() else {
            return segmentToCategory(segment)
        }

        // Check genre first for more specific mapping
        switch genre {
        case let g where g.contains("comedy"): return .comedy
        case let g where g.contains("theatre"), let g where g.contains("theater"),
             let g where g.contains("musical"), let g where g.contains("opera"):
            return .theater
        case let g where g.contains("food"), let g where g.contains("dining"),
             let g where g.contains("wine"), let g where g.contains("beer"):
            return .food
        default:
            return segmentToCategory(segment)
        }
    }

    private func segmentToCategory(_ segment: String) -> EventCategory {
        switch segment {
        case "music": return .concerts
        case "arts & theatre", "arts & theater": return .theater
        case "sports": return .outdoors
        case "film": return .theater
        default: return .concerts
        }
    }

    private func formatPrice() -> String {
        guard let range = priceRanges?.first else { return "See tickets" }
        let min = range.min ?? 0
        if min == 0 { return "Free" }
        return "$\(Int(min))"
    }

    private func formatTime(_ time: String) -> String {
        // Convert "19:00:00" to "7:00 PM"
        let parts = time.split(separator: ":")
        guard parts.count >= 2, let hour = Int(parts[0]) else { return time }
        let minute = parts[1]
        let period = hour >= 12 ? "PM" : "AM"
        let displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour)
        return "\(displayHour):\(minute) \(period)"
    }

    private func bestImage() -> String? {
        // Prefer 16:9 ratio images, medium to large size
        let preferred = images?.sorted { img1, img2 in
            let score1 = imageScore(img1)
            let score2 = imageScore(img2)
            return score1 > score2
        }
        return preferred?.first?.url
    }

    private func imageScore(_ image: TicketmasterImage) -> Int {
        var score = 0
        if image.ratio == "16_9" { score += 10 }
        let width = image.width ?? 0
        if width >= 500 && width <= 1200 { score += 5 }
        return score
    }
}

struct TicketmasterDates: Decodable {
    let start: TicketmasterStart?
}

struct TicketmasterStart: Decodable {
    let localDate: String?
    let localTime: String?
    let dateTime: String?
}

struct TicketmasterClassification: Decodable {
    let segment: TicketmasterGenre?
    let genre: TicketmasterGenre?
    let subGenre: TicketmasterGenre?
}

struct TicketmasterGenre: Decodable {
    let id: String?
    let name: String?
}

struct TicketmasterPriceRange: Decodable {
    let min: Double?
    let max: Double?
    let currency: String?
}

struct TicketmasterImage: Decodable {
    let url: String?
    let ratio: String?
    let width: Int?
    let height: Int?
}

struct TicketmasterEventVenues: Decodable {
    let venues: [TicketmasterVenue]?
}

struct TicketmasterVenue: Decodable {
    let name: String?
    let city: TicketmasterCity?
    let state: TicketmasterState?
    let address: TicketmasterAddress?
}

struct TicketmasterCity: Decodable {
    let name: String?
}

struct TicketmasterState: Decodable {
    let name: String?
    let stateCode: String?
}

struct TicketmasterAddress: Decodable {
    let line1: String?
}
