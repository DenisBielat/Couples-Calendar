import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1 // Start on Explore tab

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Calendar", systemImage: "calendar", value: 0) {
                PlaceholderTabView(
                    icon: "calendar",
                    title: "Calendar",
                    subtitle: "Your shared calendar"
                )
            }

            Tab("Explore", systemImage: "sparkles", value: 1) {
                ExploreView()
            }

            Tab("Date Builder", systemImage: "heart.text.square", value: 2) {
                PlaceholderTabView(
                    icon: "heart.text.square",
                    title: "Date Builder",
                    subtitle: "Build your perfect date"
                )
            }

            Tab("Us", systemImage: "person.2", value: 3) {
                PlaceholderTabView(
                    icon: "person.2",
                    title: "Us",
                    subtitle: "Your couple profile"
                )
            }
        }
        .tint(AppTheme.pink)
    }
}

// MARK: - Placeholder for other tabs

struct PlaceholderTabView: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.pink)

            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(AppTheme.textPrimary)

            Text(subtitle)
                .font(.system(size: 15))
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background)
    }
}

#Preview {
    MainTabView()
        .preferredColorScheme(.dark)
}
