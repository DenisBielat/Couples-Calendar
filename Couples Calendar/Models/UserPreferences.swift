import Foundation

/// Extended user preferences for date composition personalization
struct UserPreferences: Codable {
    var favoriteTeams: [String]
    var favoriteSports: [String]
    var musicGenres: [String]
    var movieGenres: [String]
    var foodPreferences: [String]
    var dateVibes: [String]
    var budgetPreference: String?

    init(
        favoriteTeams: [String] = [],
        favoriteSports: [String] = [],
        musicGenres: [String] = [],
        movieGenres: [String] = [],
        foodPreferences: [String] = [],
        dateVibes: [String] = [],
        budgetPreference: String? = nil
    ) {
        self.favoriteTeams = favoriteTeams
        self.favoriteSports = favoriteSports
        self.musicGenres = musicGenres
        self.movieGenres = movieGenres
        self.foodPreferences = foodPreferences
        self.dateVibes = dateVibes
        self.budgetPreference = budgetPreference
    }
}
