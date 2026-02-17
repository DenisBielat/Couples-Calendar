import Foundation
import SwiftUI

@Observable
final class ExploreViewModel {
    var selectedCategory: EventCategory = .all
    var selectedDateFilter: DateFilter = .anytime
    var searchText: String = ""
    var savedEventIDs: Set<String> = []

    // Custom date range (for .custom filter)
    var customStartDate: Date = Date()
    var customEndDate: Date = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
    var showDatePicker: Bool = false

    // Ticketmaster events
    var featuredEventsFromAPI: [Event] = []
    var tonightEventsFromAPI: [Event] = []

    // Community events from Firestore
    var communityEventsFromFirestore: [Event] = []

    // Loading & error states
    var isLoadingFeatured: Bool = false
    var isLoadingTonight: Bool = false
    var isLoadingCommunity: Bool = false
    var featuredError: String?
    var tonightError: String?
    var communityError: String?
    var isSaving: Bool = false

    // Location
    let locationManager = LocationManager.shared

    // For now, use a placeholder couple ID (will be replaced with real auth later)
    let placeholderCoupleId = "demo-couple"
    let placeholderUserId = "demo-user"

    // MARK: - Computed Properties

    /// The active date range based on the selected filter
    var activeDateRange: (start: Date, end: Date)? {
        if selectedDateFilter == .custom {
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: customEndDate))!
            return (Calendar.current.startOfDay(for: customStartDate), endOfDay)
        }
        return selectedDateFilter.dateRange
    }

    /// Label showing what date range is active (for custom filter)
    var dateFilterLabel: String? {
        guard selectedDateFilter == .custom else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "\(formatter.string(from: customStartDate)) – \(formatter.string(from: customEndDate))"
    }

    var featuredEvents: [Event] {
        let events = featuredEventsFromAPI.isEmpty
            ? MockData.featuredEvents
            : featuredEventsFromAPI
        return filterEvents(events)
    }

    var tonightEvents: [Event] {
        // If a date filter other than "Anytime" or "Today" is set, hide the tonight section
        // since it's redundant with the filtered results
        if selectedDateFilter != .anytime && selectedDateFilter != .today {
            return []
        }
        let events = tonightEventsFromAPI.isEmpty
            ? MockData.tonightEvents
            : tonightEventsFromAPI
        return filterByCategory(events)
    }

    var communityEvents: [Event] {
        let events = communityEventsFromFirestore.isEmpty
            ? MockData.communityEvents
            : communityEventsFromFirestore
        return filterEvents(events)
    }

    var quickDateIdeas: [QuickDateIdea] {
        MockData.quickDateIdeas
    }

    // MARK: - Actions

    func selectCategory(_ category: EventCategory) {
        withAnimation(.easeInOut(duration: 0.25)) {
            selectedCategory = category
        }

        // If selecting a specific category, fetch category-specific events from Ticketmaster
        if category != .all {
            Task { await loadCategoryEvents(category) }
        }
    }

    func selectDateFilter(_ filter: DateFilter) {
        withAnimation(.easeInOut(duration: 0.25)) {
            if filter == .custom {
                showDatePicker = true
                return
            }
            selectedDateFilter = filter
        }

        // When switching to a date filter with an API-supported range, refetch from Ticketmaster
        if filter != .anytime && filter != .custom {
            Task { await loadFilteredEvents() }
        }
    }

    func applyCustomDateRange() {
        withAnimation(.easeInOut(duration: 0.25)) {
            selectedDateFilter = .custom
            showDatePicker = false
        }
        Task { await loadFilteredEvents() }
    }

    func toggleSaved(eventID: String, source: EventSource = .community) {
        let wasSaved = savedEventIDs.contains(eventID)

        // Optimistic UI update
        if wasSaved {
            savedEventIDs.remove(eventID)
        } else {
            savedEventIDs.insert(eventID)
        }

        // Persist to Firestore
        Task {
            do {
                if wasSaved {
                    try await SavedEventService.shared.unsaveEvent(
                        coupleId: placeholderCoupleId,
                        eventId: eventID
                    )
                } else {
                    try await SavedEventService.shared.saveEvent(
                        coupleId: placeholderCoupleId,
                        eventId: eventID,
                        source: source,
                        userId: placeholderUserId
                    )
                }
            } catch {
                // Revert on failure
                if wasSaved {
                    savedEventIDs.insert(eventID)
                } else {
                    savedEventIDs.remove(eventID)
                }
                print("Failed to toggle save: \(error.localizedDescription)")
            }
        }
    }

    func isEventSaved(_ eventID: String) -> Bool {
        savedEventIDs.contains(eventID)
    }

    // MARK: - Data Loading

    func loadData() async {
        // Request location first
        locationManager.requestPermission()
        locationManager.requestLocation()

        // Small delay to let location resolve
        try? await Task.sleep(for: .milliseconds(500))

        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadFeaturedEvents() }
            group.addTask { await self.loadTonightEvents() }
            group.addTask { await self.loadCommunityEvents() }
            group.addTask { await self.loadSavedEvents() }
        }
    }

    func loadFeaturedEvents() async {
        isLoadingFeatured = true
        featuredError = nil

        do {
            let events = try await TicketmasterService.shared.fetchFeaturedEvents(
                latitude: locationManager.effectiveLatitude,
                longitude: locationManager.effectiveLongitude,
                radius: 25
            )
            featuredEventsFromAPI = events
        } catch {
            featuredError = error.localizedDescription
            print("Failed to load featured events: \(error.localizedDescription)")
        }

        isLoadingFeatured = false
    }

    func loadTonightEvents() async {
        isLoadingTonight = true
        tonightError = nil

        do {
            let events = try await TicketmasterService.shared.fetchTonightEvents(
                latitude: locationManager.effectiveLatitude,
                longitude: locationManager.effectiveLongitude,
                radius: 25
            )
            tonightEventsFromAPI = events
        } catch {
            tonightError = error.localizedDescription
            print("Failed to load tonight events: \(error.localizedDescription)")
        }

        isLoadingTonight = false
    }

    func loadCategoryEvents(_ category: EventCategory) async {
        isLoadingFeatured = true

        do {
            let events = try await TicketmasterService.shared.fetchEventsByCategory(
                category: category,
                latitude: locationManager.effectiveLatitude,
                longitude: locationManager.effectiveLongitude
            )
            if !events.isEmpty {
                featuredEventsFromAPI = events
            }
        } catch {
            print("Failed to load category events: \(error.localizedDescription)")
        }

        isLoadingFeatured = false
    }

    /// Re-fetch events with the current date filter applied at the API level
    func loadFilteredEvents() async {
        isLoadingFeatured = true

        do {
            let events = try await TicketmasterService.shared.fetchFeaturedEvents(
                latitude: locationManager.effectiveLatitude,
                longitude: locationManager.effectiveLongitude,
                radius: 25,
                startDate: activeDateRange?.start,
                endDate: activeDateRange?.end
            )
            featuredEventsFromAPI = events
        } catch {
            print("Failed to load filtered events: \(error.localizedDescription)")
        }

        isLoadingFeatured = false
    }

    func loadCommunityEvents() async {
        isLoadingCommunity = true
        communityError = nil

        do {
            // Seed sample data on first launch
            try await CommunityEventService.shared.seedSampleEvents()

            // Fetch approved events
            let events = try await CommunityEventService.shared.fetchApprovedEvents()
            communityEventsFromFirestore = events
        } catch {
            communityError = error.localizedDescription
            print("Failed to load community events: \(error.localizedDescription)")
        }

        isLoadingCommunity = false
    }

    func loadSavedEvents() async {
        do {
            savedEventIDs = try await SavedEventService.shared.fetchSavedEventIDs(
                coupleId: placeholderCoupleId
            )
        } catch {
            print("Failed to load saved events: \(error.localizedDescription)")
        }
    }

    func refresh() async {
        TicketmasterService.shared.clearCache()
        await loadData()
    }

    // MARK: - Private

    /// Apply both category and date filters
    private func filterEvents(_ events: [Event]) -> [Event] {
        var filtered = filterByCategory(events)
        filtered = filterByDate(filtered)
        return filtered
    }

    private func filterByCategory(_ events: [Event]) -> [Event] {
        if selectedCategory == .all {
            return events
        }
        return events.filter { $0.category == selectedCategory }
    }

    private func filterByDate(_ events: [Event]) -> [Event] {
        guard let range = activeDateRange else {
            return events
        }
        return events.filter { $0.hasDateInRange(start: range.start, end: range.end) }
    }
}
