import Foundation
import SwiftUI

// MARK: - Cost Level

enum CostLevel: String, Codable, CaseIterable {
    case free = "Free"
    case budget = "$"
    case moderate = "$$"
    case upscale = "$$$"
    case luxury = "$$$$"

    var icon: String {
        switch self {
        case .free: return "gift"
        case .budget, .moderate, .upscale: return "dollarsign"
        case .luxury: return "crown"
        }
    }

    var color: Color {
        switch self {
        case .free, .budget: return Color(hex: "2D8B4E")
        case .moderate: return Color(hex: "D4A017")
        case .upscale: return Color(hex: "C44B2B")
        case .luxury: return Color(hex: "8B2252")
        }
    }
}

// MARK: - Cost Estimate

struct CostEstimate: Codable {
    let level: CostLevel
    let min: Int
    let max: Int
    let note: String?

    var formattedRange: String {
        if level == .free { return "Free" }
        if min == max { return "$\(min)" }
        return "$\(min)–$\(max)"
    }
}
