import SwiftUI

struct ExploreView: View {
    @State private var viewModel = ExploreViewModel()

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                headerSection

                // Search bar
                searchBar

                // Category filter chips
                categoryChips

                // Featured Date Ideas
                if !viewModel.featuredEvents.isEmpty {
                    featuredSection
                }

                // Tonight
                if !viewModel.tonightEvents.isEmpty {
                    tonightSection
                }

                // Community Events
                if !viewModel.communityEvents.isEmpty {
                    communitySection
                }

                // Quick Date Ideas
                quickIdeasSection

                Spacer(minLength: 100)
            }
            .padding(.top, 8)
        }
        .background(AppTheme.background)
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Explore")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(AppTheme.textPrimary)

                Text("Find your next date night")
                    .font(.system(size: 15))
                    .foregroundStyle(AppTheme.textSecondary)
            }

            Spacer()

            // Character avatar placeholder
            ZStack {
                Circle()
                    .fill(AppTheme.pinkGradient)
                    .frame(width: 44, height: 44)

                Image(systemName: "heart.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundStyle(AppTheme.textTertiary)

            TextField("Search events, activities...", text: $viewModel.searchText)
                .font(.system(size: 15))
                .foregroundStyle(AppTheme.textPrimary)

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(AppTheme.textTertiary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 20)
    }

    // MARK: - Category Chips

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(EventCategory.allCases) { category in
                    CategoryChipView(
                        category: category,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectCategory(category)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Featured Section

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader("Featured Date Ideas") {}

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.featuredEvents) { event in
                        FeaturedEventCard(
                            event: event,
                            isSaved: viewModel.isEventSaved(event.id)
                        ) {
                            viewModel.toggleSaved(eventID: event.id)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Tonight Section

    private var tonightSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader("Tonight") {}

            VStack(spacing: 10) {
                ForEach(viewModel.tonightEvents) { event in
                    CompactEventRow(event: event)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Community Section

    private var communitySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader("Community Events") {}

            VStack(spacing: 12) {
                ForEach(viewModel.communityEvents) { event in
                    CommunityEventCard(event: event)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Quick Ideas Section

    private var quickIdeasSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader("Quick Date Ideas", actionLabel: nil)

            FlowLayout(spacing: 10) {
                ForEach(viewModel.quickDateIdeas) { idea in
                    QuickIdeaTag(idea: idea) {}
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Flow Layout for tag cloud

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }

            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            maxX = max(maxX, currentX)
        }

        return (positions, CGSize(width: maxX, height: currentY + lineHeight))
    }
}

#Preview {
    ExploreView()
}
