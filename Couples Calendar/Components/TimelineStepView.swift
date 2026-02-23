import SwiftUI

struct TimelineStepView: View {
    let steps: [DateStep]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    // Timeline connector
                    VStack(spacing: 0) {
                        Circle()
                            .fill(dotColor(for: step.role))
                            .frame(width: 10, height: 10)
                            .padding(.top, 4)

                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(AppTheme.textTertiary.opacity(0.4))
                                .frame(width: 1.5)
                                .frame(maxHeight: .infinity)
                        }
                    }
                    .frame(width: 10)

                    // Step content
                    VStack(alignment: .leading, spacing: 3) {
                        Text(step.role.label)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(dotColor(for: step.role))
                            .textCase(.uppercase)

                        Text(step.title)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(AppTheme.textPrimary)
                            .lineLimit(2)

                        HStack(spacing: 8) {
                            if let venue = step.venueName {
                                HStack(spacing: 3) {
                                    Image(systemName: "mappin")
                                        .font(.system(size: 9))
                                    Text(venue)
                                        .font(.system(size: 11))
                                }
                                .foregroundStyle(AppTheme.textSecondary)
                            }

                            if let time = step.time {
                                HStack(spacing: 3) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 9))
                                    Text(time)
                                        .font(.system(size: 11))
                                }
                                .foregroundStyle(AppTheme.textSecondary)
                            }

                            if let duration = step.formattedDuration {
                                Text(duration)
                                    .font(.system(size: 11))
                                    .foregroundStyle(AppTheme.textTertiary)
                            }
                        }
                    }
                    .padding(.bottom, index < steps.count - 1 ? 16 : 0)
                }
            }
        }
    }

    private func dotColor(for role: StepRole) -> Color {
        switch role {
        case .before: return AppTheme.textSecondary
        case .main: return AppTheme.pink
        case .after: return AppTheme.pinkSecondary
        }
    }
}

#Preview {
    TimelineStepView(steps: MockDateCompositions.featured[0].steps)
        .padding()
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding()
        .background(AppTheme.background)
}
