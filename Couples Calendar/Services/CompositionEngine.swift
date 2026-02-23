import Foundation

final class CompositionEngine {
    static let shared = CompositionEngine()
    private let templateService = TemplateService.shared

    private init() {}

    // MARK: - Public

    /// Compose a full date experience from an event using the best matching template
    func compose(from event: Event) -> DateComposition? {
        guard let template = templateService.bestTemplate(for: event) else {
            return nil
        }
        return compose(event: event, template: template)
    }

    /// Compose using a specific template
    func compose(event: Event, template: DateTemplate) -> DateComposition {
        let steps = template.steps.map { templateStep in
            resolveStep(templateStep, event: event)
        }

        return DateComposition(
            id: "comp_\(event.id)_\(template.id ?? "t")",
            title: resolveTokens(template.name, event: event),
            subtitle: buildSubtitle(event: event),
            category: event.category,
            steps: steps,
            estimatedCost: template.costEstimate,
            dateCoins: template.dateCoins,
            imageURL: event.imageURL,
            tags: Array(Set(event.tags + template.tags)),
            source: .composed,
            anchorEventId: event.id
        )
    }

    /// Batch-compose: turn an array of events into compositions
    func composeAll(from events: [Event]) -> [DateComposition] {
        events.compactMap { compose(from: $0) }
    }

    // MARK: - Token Resolution

    private func resolveTokens(_ template: String, event: Event) -> String {
        template
            .replacingOccurrences(of: "{venue}", with: event.venue)
            .replacingOccurrences(of: "{title}", with: event.title)
            .replacingOccurrences(of: "{time}", with: event.time)
            .replacingOccurrences(of: "{date}", with: event.formattedDate)
    }

    private func resolveStep(_ templateStep: TemplateStep, event: Event) -> DateStep {
        DateStep(
            id: UUID().uuidString,
            order: templateStep.order,
            role: templateStep.stepRole ?? .main,
            title: resolveTokens(templateStep.titleTemplate, event: event),
            description: templateStep.descriptionTemplate.map { resolveTokens($0, event: event) },
            venueName: templateStep.isAnchorEvent ? event.venue : nil,
            venueAddress: nil,
            time: templateStep.isAnchorEvent ? event.time : nil,
            durationMinutes: templateStep.durationMinutes,
            externalURL: nil,
            placeId: nil,
            imageURL: templateStep.isAnchorEvent ? event.imageURL : nil
        )
    }

    private func buildSubtitle(event: Event) -> String {
        "\(event.venue) \u{00B7} \(event.formattedDate)"
    }
}
