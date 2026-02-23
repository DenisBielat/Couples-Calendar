import Foundation
import FirebaseFirestore

final class TemplateService {
    static let shared = TemplateService()
    private let firestore = FirestoreService.shared
    private let collectionName = "dateTemplates"

    private var templates: [DateTemplate] = []
    private var lastFetch: Date?
    private let cacheTTL: TimeInterval = 60 * 60 // 1 hour

    private init() {}

    // MARK: - Public

    func fetchTemplates(forceRefresh: Bool = false) async throws -> [DateTemplate] {
        if !forceRefresh, !templates.isEmpty,
           let lastFetch, Date().timeIntervalSince(lastFetch) < cacheTTL {
            return templates
        }

        let query = firestore.db
            .collection(collectionName)
            .whereField("isActive", isEqualTo: true)

        let fetched: [DateTemplate] = try await firestore.getDocuments(query: query)
        self.templates = fetched
        self.lastFetch = Date()
        return fetched
    }

    func bestTemplate(for event: Event) -> DateTemplate? {
        templates.first { template in
            guard let matchCategory = template.matchesCategory else { return false }
            return matchCategory == event.category
        }
    }

    func templates(for category: EventCategory) -> [DateTemplate] {
        templates.filter { $0.matchesCategory == category }
    }

    func seedDefaultTemplates() async throws {
        let snapshot = try await firestore.db
            .collection(collectionName)
            .limit(to: 1)
            .getDocuments()

        guard snapshot.documents.isEmpty else { return }

        let seeds = Self.defaultTemplates()
        for template in seeds {
            _ = try await firestore.createDocument(collection: collectionName, data: template)
        }
    }

    // MARK: - Default Templates

    static func defaultTemplates() -> [DateTemplate] {
        let now = Timestamp(date: Date())

        return [
            // Concerts: dinner -> concert -> nightcap
            DateTemplate(
                name: "Concert Night Out",
                category: "Concerts",
                steps: [
                    TemplateStep(order: 1, role: "before", titleTemplate: "Dinner near {venue}", descriptionTemplate: "Grab a bite before the show", venueType: "restaurant", durationMinutes: 75, isAnchorEvent: false),
                    TemplateStep(order: 2, role: "main", titleTemplate: "{title} at {venue}", descriptionTemplate: nil, venueType: nil, durationMinutes: 120, isAnchorEvent: true),
                    TemplateStep(order: 3, role: "after", titleTemplate: "Late-night drinks nearby", descriptionTemplate: "Wind down and talk about the show", venueType: "bar", durationMinutes: 60, isAnchorEvent: false)
                ],
                costEstimate: CostEstimate(level: .moderate, min: 60, max: 120, note: "Dinner + tickets + drinks"),
                dateCoins: 12,
                tags: ["music", "live", "nightlife"],
                isActive: true,
                createdAt: now
            ),

            // Sports: pre-game -> game -> bar
            DateTemplate(
                name: "Game Day Experience",
                category: "Sports",
                steps: [
                    TemplateStep(order: 1, role: "before", titleTemplate: "Pre-game food near {venue}", descriptionTemplate: "Fuel up before the game", venueType: "restaurant", durationMinutes: 90, isAnchorEvent: false),
                    TemplateStep(order: 2, role: "main", titleTemplate: "{title} at {venue}", descriptionTemplate: nil, venueType: nil, durationMinutes: 180, isAnchorEvent: true),
                    TemplateStep(order: 3, role: "after", titleTemplate: "Post-game celebration", descriptionTemplate: "Celebrate (or commiserate) with a drink", venueType: "bar", durationMinutes: 90, isAnchorEvent: false)
                ],
                costEstimate: CostEstimate(level: .moderate, min: 80, max: 160, note: "Tickets + food & drinks"),
                dateCoins: 15,
                tags: ["sports", "game day", "energy"],
                isActive: true,
                createdAt: now
            ),

            // Comedy: dinner -> show -> dessert
            DateTemplate(
                name: "Laugh Date Night",
                category: "Comedy",
                steps: [
                    TemplateStep(order: 1, role: "before", titleTemplate: "Dinner before the laughs", descriptionTemplate: "Set the mood with a good meal", venueType: "restaurant", durationMinutes: 75, isAnchorEvent: false),
                    TemplateStep(order: 2, role: "main", titleTemplate: "{title} at {venue}", descriptionTemplate: nil, venueType: nil, durationMinutes: 90, isAnchorEvent: true),
                    TemplateStep(order: 3, role: "after", titleTemplate: "Dessert & nightcap", descriptionTemplate: "End on a sweet note", venueType: "cafe", durationMinutes: 45, isAnchorEvent: false)
                ],
                costEstimate: CostEstimate(level: .moderate, min: 60, max: 110, note: "Dinner + tickets + dessert"),
                dateCoins: 12,
                tags: ["comedy", "laughs", "dinner"],
                isActive: true,
                createdAt: now
            ),

            // Theater: drinks -> show -> dinner
            DateTemplate(
                name: "Theater Evening",
                category: "Theater",
                steps: [
                    TemplateStep(order: 1, role: "before", titleTemplate: "Pre-show cocktails", descriptionTemplate: "Get in the mood with a nice drink", venueType: "bar", durationMinutes: 45, isAnchorEvent: false),
                    TemplateStep(order: 2, role: "main", titleTemplate: "{title} at {venue}", descriptionTemplate: nil, venueType: nil, durationMinutes: 150, isAnchorEvent: true),
                    TemplateStep(order: 3, role: "after", titleTemplate: "Post-show dinner", descriptionTemplate: "Discuss the show over a great meal", venueType: "restaurant", durationMinutes: 75, isAnchorEvent: false)
                ],
                costEstimate: CostEstimate(level: .upscale, min: 100, max: 200, note: "Drinks + tickets + dinner"),
                dateCoins: 15,
                tags: ["theater", "culture", "classy"],
                isActive: true,
                createdAt: now
            ),

            // Food: market -> cooking -> walk
            DateTemplate(
                name: "Foodie Adventure",
                category: "Food",
                steps: [
                    TemplateStep(order: 1, role: "before", titleTemplate: "Browse a local market", descriptionTemplate: "Pick up fresh ingredients and treats", venueType: "market", durationMinutes: 60, isAnchorEvent: false),
                    TemplateStep(order: 2, role: "main", titleTemplate: "{title} at {venue}", descriptionTemplate: nil, venueType: nil, durationMinutes: 120, isAnchorEvent: true),
                    TemplateStep(order: 3, role: "after", titleTemplate: "Dessert walk", descriptionTemplate: "Stroll and enjoy something sweet", venueType: "cafe", durationMinutes: 45, isAnchorEvent: false)
                ],
                costEstimate: CostEstimate(level: .moderate, min: 50, max: 100, note: "Market + experience + treats"),
                dateCoins: 12,
                tags: ["food", "cooking", "adventure"],
                isActive: true,
                createdAt: now
            ),

            // Outdoors: coffee -> activity -> sunset drinks
            DateTemplate(
                name: "Outdoor Day Date",
                category: "Outdoors",
                steps: [
                    TemplateStep(order: 1, role: "before", titleTemplate: "Coffee to start the day", descriptionTemplate: "Fuel up with caffeine", venueType: "cafe", durationMinutes: 30, isAnchorEvent: false),
                    TemplateStep(order: 2, role: "main", titleTemplate: "{title} at {venue}", descriptionTemplate: nil, venueType: nil, durationMinutes: 120, isAnchorEvent: true),
                    TemplateStep(order: 3, role: "after", titleTemplate: "Sunset drinks", descriptionTemplate: "Wind down with a view", venueType: "bar", durationMinutes: 60, isAnchorEvent: false)
                ],
                costEstimate: CostEstimate(level: .budget, min: 20, max: 60, note: "Coffee + activity + drinks"),
                dateCoins: 10,
                tags: ["outdoors", "active", "nature"],
                isActive: true,
                createdAt: now
            ),

            // Movies: dinner -> movie -> dessert
            DateTemplate(
                name: "Movie Night Out",
                category: "Movies",
                steps: [
                    TemplateStep(order: 1, role: "before", titleTemplate: "Dinner before the movie", descriptionTemplate: "Grab a meal nearby", venueType: "restaurant", durationMinutes: 60, isAnchorEvent: false),
                    TemplateStep(order: 2, role: "main", titleTemplate: "{title}", descriptionTemplate: nil, venueType: nil, durationMinutes: 135, isAnchorEvent: true),
                    TemplateStep(order: 3, role: "after", titleTemplate: "Nightcap & movie chat", descriptionTemplate: "Discuss the film over drinks", venueType: "bar", durationMinutes: 60, isAnchorEvent: false)
                ],
                costEstimate: CostEstimate(level: .moderate, min: 50, max: 90, note: "Dinner + tickets + drinks"),
                dateCoins: 10,
                tags: ["movies", "dinner", "cozy"],
                isActive: true,
                createdAt: now
            )
        ]
    }
}
