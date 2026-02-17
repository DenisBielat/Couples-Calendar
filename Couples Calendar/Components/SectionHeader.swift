import SwiftUI

struct SectionHeader: View {
    let title: String
    let actionLabel: String?
    let action: (() -> Void)?

    init(_ title: String, actionLabel: String? = "See all", action: (() -> Void)? = nil) {
        self.title = title
        self.actionLabel = actionLabel
        self.action = action
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AppTheme.textPrimary)

            Spacer()

            if let actionLabel, let action {
                Button(action: action) {
                    Text(actionLabel)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppTheme.pink)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    VStack {
        SectionHeader("Featured Date Ideas", action: {})
        SectionHeader("Tonight", actionLabel: nil)
    }
    .background(AppTheme.background)
}
