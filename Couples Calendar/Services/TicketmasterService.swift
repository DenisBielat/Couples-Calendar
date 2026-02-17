import Foundation

/// Service for fetching events from the Ticketmaster Discovery API
final class TicketmasterService {
    static let shared = TicketmasterService()

    private let baseURL = APIConfig.ticketmasterBaseURL
    private let apiKey = APIConfig.ticketmasterAPIKey

    // In-memory cache with TTL
    private var cache: [String: CachedResponse] = [:]
    private let cacheTTL: TimeInterval = 30 * 60 // 30 minutes

    private init() {}

    // MARK: - Public Methods

    /// Fetch featured events (popular, upcoming) near a location
    /// Optionally pass startDate/endDate to filter by a specific date range
    func fetchFeaturedEvents(
        latitude: Double,
        longitude: Double,
        radius: Int = 25,
        size: Int = 50,
        startDate: Date? = nil,
        endDate: Date? = nil
    ) async throws -> [Event] {
        var params: [String: String] = [
            "latlong": "\(latitude),\(longitude)",
            "radius": "\(radius)",
            "unit": "miles",
            "size": "\(size)",
            "sort": "relevance,desc",
            "locale": "*"
        ]

        // Add date range if provided
        if let start = startDate {
            params["startDateTime"] = formattedDateTime(start)
        }
        if let end = endDate {
            params["endDateTime"] = formattedDateTime(end)
        }

        let cacheKey = startDate != nil
            ? "featured_\(radius)_\(formattedDate(startDate!))_\(formattedDate(endDate ?? startDate!))"
            : "featured_\(radius)"
        let events = try await fetchEvents(params: params, cacheKey: cacheKey)
        return events
    }

    /// Fetch events happening today near a location
    func fetchTonightEvents(
        latitude: Double,
        longitude: Double,
        radius: Int = 25,
        size: Int = 20
    ) async throws -> [Event] {
        let today = formattedDate(Date())
        let tomorrow = formattedDate(Calendar.current.date(byAdding: .day, value: 1, to: Date())!)

        let params: [String: String] = [
            "latlong": "\(latitude),\(longitude)",
            "radius": "\(radius)",
            "unit": "miles",
            "size": "\(size)",
            "startDateTime": "\(today)T00:00:00Z",
            "endDateTime": "\(tomorrow)T00:00:00Z",
            "sort": "date,asc",
            "locale": "*"
        ]
        let events = try await fetchEvents(params: params, cacheKey: "tonight")
        return events
    }

    /// Fetch events by category near a location
    func fetchEventsByCategory(
        category: EventCategory,
        latitude: Double,
        longitude: Double,
        radius: Int = 25,
        size: Int = 20
    ) async throws -> [Event] {
        guard let classification = categoryToClassification(category) else {
            return []
        }

        var params: [String: String] = [
            "latlong": "\(latitude),\(longitude)",
            "radius": "\(radius)",
            "unit": "miles",
            "size": "\(size)",
            "sort": "date,asc",
            "locale": "*"
        ]
        params["classificationName"] = classification

        let events = try await fetchEvents(params: params, cacheKey: "cat_\(category.rawValue)")
        return events
    }

    /// Search events by keyword
    func searchEvents(
        keyword: String,
        latitude: Double,
        longitude: Double,
        radius: Int = 25,
        size: Int = 20
    ) async throws -> [Event] {
        let params: [String: String] = [
            "keyword": keyword,
            "latlong": "\(latitude),\(longitude)",
            "radius": "\(radius)",
            "unit": "miles",
            "size": "\(size)",
            "sort": "relevance,desc",
            "locale": "*"
        ]
        // Don't cache search results
        return try await fetchEvents(params: params, cacheKey: nil)
    }

    /// Clear the in-memory cache
    func clearCache() {
        cache.removeAll()
    }

    // MARK: - Private Methods

    private func fetchEvents(params: [String: String], cacheKey: String?) async throws -> [Event] {
        // Check cache
        if let key = cacheKey, let cached = cache[key], !cached.isExpired {
            return cached.events
        }

        // Build URL
        var components = URLComponents(string: "\(baseURL)/events.json")!
        var queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        queryItems.append(URLQueryItem(name: "apikey", value: apiKey))
        components.queryItems = queryItems

        guard let url = components.url else {
            throw TicketmasterError.invalidURL
        }

        // Make request
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw TicketmasterError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 429 {
                throw TicketmasterError.rateLimited
            }
            throw TicketmasterError.httpError(httpResponse.statusCode)
        }

        // Decode and deduplicate
        let decoded = try JSONDecoder().decode(TicketmasterResponse.self, from: data)
        let rawEvents = decoded.embedded?.events?.map { $0.toEvent() } ?? []
        let events = rawEvents.deduplicated()

        // Cache results
        if let key = cacheKey {
            cache[key] = CachedResponse(events: events, timestamp: Date())
        }

        return events
    }

    private func categoryToClassification(_ category: EventCategory) -> String? {
        switch category {
        case .all: return nil
        case .concerts: return "Music"
        case .comedy: return "Comedy"
        case .theater: return "Theatre"
        case .outdoors: return "Sports"
        case .food: return nil // Not well covered by Ticketmaster
        case .classes: return nil // Not covered by Ticketmaster
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }
}

// MARK: - Cache

private struct CachedResponse {
    let events: [Event]
    let timestamp: Date

    var isExpired: Bool {
        Date().timeIntervalSince(timestamp) > 30 * 60 // 30 minutes
    }
}

// MARK: - Errors

enum TicketmasterError: LocalizedError {
    case invalidURL
    case invalidResponse
    case rateLimited
    case httpError(Int)
    case noResults

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid request URL"
        case .invalidResponse: return "Invalid server response"
        case .rateLimited: return "Too many requests. Please try again in a moment."
        case .httpError(let code): return "Server error (code: \(code))"
        case .noResults: return "No events found in your area"
        }
    }
}
