import SwiftUI

struct CompactEventRow: View {
    let event: Event

    var body: some View {
        HStack(spacing: 14) {
            // Category icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppTheme.cardBackgroundLight)
                    .frame(width: 48, height: 48)

                Image(systemName: event.category.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(AppTheme.pink)
            }

            // Event info
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppTheme.textPrimary)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.system(size: 10))
                    Text(event.venue)
                        .font(.system(size: 13))
                }
                .foregroundStyle(AppTheme.textSecondary)
                .lineLimit(1)
            }

            Spacer()

            // Time and price
            VStack(alignment: .trailing, spacing: 4) {
                Text(event.time)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppTheme.textPrimary)

                Text(event.price)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppTheme.pink)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    VStack {
        CompactEventRow(event: MockData.tonightEvents[0])
        CompactEventRow(event: MockData.tonightEvents[1])
    }
    .padding()
    .background(AppTheme.background)
}
