import SwiftUI

struct CategoryChipView: View {
    let category: EventCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 12))
                Text(category.rawValue)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                isSelected
                    ? AnyShapeStyle(AppTheme.pinkGradient)
                    : AnyShapeStyle(AppTheme.cardBackground)
            )
            .foregroundStyle(isSelected ? .white : AppTheme.textSecondary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(
                        isSelected ? Color.clear : AppTheme.textTertiary.opacity(0.3),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        CategoryChipView(category: .concerts, isSelected: true, action: {})
        CategoryChipView(category: .comedy, isSelected: false, action: {})
    }
    .padding()
    .background(AppTheme.background)
}
