import SwiftUI

struct QuickIdeaTag: View {
    let idea: QuickDateIdea
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(idea.emoji)
                    .font(.system(size: 14))
                Text(idea.title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppTheme.textPrimary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(AppTheme.cardBackground)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(AppTheme.textTertiary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        QuickIdeaTag(idea: MockData.quickDateIdeas[0], action: {})
        QuickIdeaTag(idea: MockData.quickDateIdeas[1], action: {})
    }
    .padding()
    .background(AppTheme.background)
}
