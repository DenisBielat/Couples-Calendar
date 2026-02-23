import SwiftUI

struct CostBadge: View {
    let cost: CostEstimate

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: cost.level.icon)
                .font(.system(size: 10))
            Text(cost.formattedRange)
                .font(.system(size: 12, weight: .semibold))
        }
        .foregroundStyle(cost.level.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(cost.level.color.opacity(0.15))
        .clipShape(Capsule())
    }
}

#Preview {
    VStack(spacing: 8) {
        CostBadge(cost: CostEstimate(level: .free, min: 0, max: 0, note: nil))
        CostBadge(cost: CostEstimate(level: .budget, min: 15, max: 30, note: nil))
        CostBadge(cost: CostEstimate(level: .moderate, min: 50, max: 100, note: nil))
        CostBadge(cost: CostEstimate(level: .upscale, min: 100, max: 200, note: nil))
    }
    .padding()
    .background(AppTheme.background)
}
