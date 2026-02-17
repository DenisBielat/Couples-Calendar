import SwiftUI

struct CommunityEventCard: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Organizer info row
            HStack(spacing: 10) {
                // Organizer avatar placeholder
                ZStack {
                    Circle()
                        .fill(AppTheme.pinkGradient)
                        .frame(width: 36, height: 36)

                    Text(String((event.organizerName ?? "?").prefix(1)))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(event.organizerName ?? "Unknown")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(AppTheme.textPrimary)

                        if event.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(AppTheme.pink)
                        }
                    }

                    Text("Organizer")
                        .font(.system(size: 12))
                        .foregroundStyle(AppTheme.textTertiary)
                }

                Spacer()

                if let count = event.attendeeCount {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 12))
                        Text("\(count)")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(AppTheme.textSecondary)
                }
            }

            // Event title and details
            Text(event.title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(AppTheme.textPrimary)

            Text(event.description)
                .font(.system(size: 14))
                .foregroundStyle(AppTheme.textSecondary)
                .lineLimit(2)

            // Date, time, price row
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                    Text(event.formattedDate)
                        .font(.system(size: 13))
                }

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text(event.time)
                        .font(.system(size: 13))
                }

                Spacer()

                Text(event.price)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppTheme.pink)
            }
            .foregroundStyle(AppTheme.textSecondary)

            // Venue
            HStack(spacing: 4) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 13))
                Text(event.venue)
                    .font(.system(size: 13))
            }
            .foregroundStyle(AppTheme.textSecondary)
        }
        .padding(16)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    VStack {
        CommunityEventCard(event: MockData.communityEvents[0])
        CommunityEventCard(event: MockData.communityEvents[2])
    }
    .padding()
    .background(AppTheme.background)
}
