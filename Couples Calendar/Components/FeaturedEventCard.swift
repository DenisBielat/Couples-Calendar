import SwiftUI

struct FeaturedEventCard: View {
    let event: Event
    let isSaved: Bool
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image placeholder
            ZStack(alignment: .topTrailing) {
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: gradientColors(for: event.category),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Image(systemName: event.category.icon)
                        .font(.system(size: 40))
                        .foregroundStyle(.white.opacity(0.3))
                }
                .frame(height: 160)

                Button(action: onSave) {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(isSaved ? AppTheme.pink : .white)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding(12)
            }

            // Event info
            VStack(alignment: .leading, spacing: 6) {
                Text(event.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.system(size: 11))
                    Text(event.venue)
                        .font(.system(size: 13))
                }
                .foregroundStyle(AppTheme.textSecondary)
                .lineLimit(1)

                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11))
                        Text(event.formattedDate)
                            .font(.system(size: 13))
                    }
                    .foregroundStyle(AppTheme.textSecondary)

                    Spacer()

                    Text(event.price)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppTheme.pink)
                }
            }
            .padding(14)
        }
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .frame(width: 240)
    }

    private func gradientColors(for category: EventCategory) -> [Color] {
        switch category {
        case .concerts: return [Color(hex: "6B2FA0"), Color(hex: "3B1F6E")]
        case .comedy: return [Color(hex: "D4A017"), Color(hex: "8B6914")]
        case .outdoors: return [Color(hex: "2D8B4E"), Color(hex: "1A5C32")]
        case .food: return [Color(hex: "C44B2B"), Color(hex: "8B3520")]
        case .theater: return [Color(hex: "8B2252"), Color(hex: "5C1636")]
        case .classes: return [Color(hex: "2B6BC4"), Color(hex: "1A4480")]
        case .all: return [Color(hex: "6B2FA0"), Color(hex: "3B1F6E")]
        }
    }
}

#Preview {
    FeaturedEventCard(
        event: MockData.featuredEvents[0],
        isSaved: false,
        onSave: {}
    )
    .padding()
    .background(AppTheme.background)
}
