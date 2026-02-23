import Foundation

/// API keys and configuration loaded from Config.plist (gitignored).
/// Copy Config.plist.example to Config.plist and add your keys.
enum APIConfig {
    private static let config: [String: Any] = {
        guard let url = Bundle.main.url(forResource: "Config", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any]
        else {
            fatalError("Config.plist not found. Copy Config.plist.example to Config.plist and add your API keys.")
        }
        return dict
    }()

    static var ticketmasterAPIKey: String {
        config["TICKETMASTER_API_KEY"] as? String ?? ""
    }

    static let ticketmasterBaseURL = "https://app.ticketmaster.com/discovery/v2"

    static var tmdbAPIKey: String {
        config["TMDB_API_KEY"] as? String ?? ""
    }

    static var weatherAPIKey: String {
        config["WEATHER_API_KEY"] as? String ?? ""
    }

    static var googlePlacesAPIKey: String {
        config["GOOGLE_PLACES_API_KEY"] as? String ?? ""
    }
}
