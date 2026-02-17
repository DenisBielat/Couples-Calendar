import Foundation
import SwiftUI

@Observable
final class ExploreViewModel {
    var selectedCategory: EventCategory = .all
    var searchText: String = ""
    var savedEventIDs: Set<String> = []

    var featuredEvents: [Event] {
        filterByCategory(MockData.featuredEvents)
    }

    var tonightEvents: [Event] {
        filterByCategory(MockData.tonightEvents)
    }

    var communityEvents: [Event] {
        filterByCategory(MockData.communityEvents)
    }

    var quickDateIdeas: [QuickDateIdea] {
        MockData.quickDateIdeas
    }

    func selectCategory(_ category: EventCategory) {
        withAnimation(.easeInOut(duration: 0.25)) {
            selectedCategory = category
        }
    }

    func toggleSaved(eventID: String) {
        if savedEventIDs.contains(eventID) {
            savedEventIDs.remove(eventID)
        } else {
            savedEventIDs.insert(eventID)
        }
    }

    func isEventSaved(_ eventID: String) -> Bool {
        savedEventIDs.contains(eventID)
    }

    private func filterByCategory(_ events: [Event]) -> [Event] {
        if selectedCategory == .all {
            return events
        }
        return events.filter { $0.category == selectedCategory }
    }
}
