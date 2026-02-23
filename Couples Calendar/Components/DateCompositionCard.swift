import SwiftUI

struct DateCompositionCard: View {
    let composition: DateComposition
    let isSaved: Bool
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image area
            ZStack(alignment: .topTrailing) {
                imageArea
                    .frame(width: 240, height: 140)
                    .clipped()

                Button(action: onSave) {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(isSaved ? AppTheme.pink : .white)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding(10)
            }

            // Content area
            VStack(alignment: .leading, spacing: 8) {
                Text(composition.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                    .lineLimit(2)

                Text(composition.subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(AppTheme.textSecondary)
                    .lineLimit(1)

                // Step indicator (before -> main -> after)
                stepIndicator

                Spacer(minLength: 0)

                // Bottom row: cost + step count
                HStack {
                    CostBadge(cost: composition.estimatedCost)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 10))
                        Text("\(composition.stepCount) stops")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundStyle(AppTheme.textTertiary)
                }
            }
            .padding(12)
            .frame(maxHeight: .infinity)
        }
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .frame(width: 240, height: 340)
    }

    // MARK: - Subviews

    @ViewBuilder
    private var imageArea: some View {
        if let imageURL = composition.imageURL, let url = URL(string: imageURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 240, height: 140)
                        .clipped()
                case .failure:
                    fallbackImage
                case .empty:
                    RoundedRectangle(cornerRadius: 0)
                        .fill(AppTheme.cardBackground)
                        .frame(width: 240, height: 140)
                        .shimmering()
                @unknown default:
                    fallbackImage
                }
            }
        } else {
            fallbackImage
        }
    }

    private var fallbackImage: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: gradientColors(for: composition.category),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image(systemName: composition.category.icon)
                .font(.system(size: 36))
                .foregroundStyle(.white.opacity(0.3))
        }
    }

    private var stepIndicator: some View {
        HStack(spacing: 4) {
            ForEach(Array(composition.steps.sorted { $0.order < $1.order }.enumerated()), id: \.element.id) { index, step in
                Circle()
                    .fill(stepDotColor(for: step.role))
                    .frame(width: 6, height: 6)

                if index < composition.steps.count - 1 {
                    Rectangle()
                        .fill(AppTheme.textTertiary.opacity(0.4))
                        .frame(width: 12, height: 1.5)
                }
            }

            Spacer()

            if let duration = composition.totalDuration {
                Text(duration)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(AppTheme.textTertiary)
            }
        }
    }

    // MARK: - Helpers

    private func stepDotColor(for role: StepRole) -> Color {
        switch role {
        case .before: return AppTheme.textSecondary
        case .main: return AppTheme.pink
        case .after: return AppTheme.pinkSecondary
        }
    }

    private func gradientColors(for category: EventCategory) -> [Color] {
        switch category {
        case .concerts: return [Color(hex: "6B2FA0"), Color(hex: "3B1F6E")]
        case .comedy: return [Color(hex: "D4A017"), Color(hex: "8B6914")]
        case .outdoors: return [Color(hex: "2D8B4E"), Color(hex: "1A5C32")]
        case .food: return [Color(hex: "C44B2B"), Color(hex: "8B3520")]
        case .theater: return [Color(hex: "8B2252"), Color(hex: "5C1636")]
        case .classes: return [Color(hex: "2B6BC4"), Color(hex: "1A4480")]
        case .sports: return [Color(hex: "1B7A3D"), Color(hex: "0E4D26")]
        case .movies: return [Color(hex: "B8860B"), Color(hex: "6B4E08")]
        case .all: return [Color(hex: "6B2FA0"), Color(hex: "3B1F6E")]
        }
    }
}

#Preview {
    HStack {
        DateCompositionCard(
            composition: MockDateCompositions.featured[0],
            isSaved: false,
            onSave: {}
        )
        DateCompositionCard(
            composition: MockDateCompositions.featured[1],
            isSaved: true,
            onSave: {}
        )
    }
    .padding()
    .background(AppTheme.background)
}
