import Foundation
import CoreLocation

/// Manages user location for event discovery
@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    var userLatitude: Double?
    var userLongitude: Double?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var locationError: String?

    // Default to Chicago as fallback (can be changed by user)
    var fallbackLatitude: Double = 41.8781
    var fallbackLongitude: Double = -87.6298

    var effectiveLatitude: Double {
        userLatitude ?? fallbackLatitude
    }

    var effectiveLongitude: Double {
        userLongitude ?? fallbackLongitude
    }

    var hasLocation: Bool {
        userLatitude != nil && userLongitude != nil
    }

    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }

    private let manager = CLLocationManager()

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        authorizationStatus = manager.authorizationStatus
    }

    /// Request location permission
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    /// Request a one-time location update
    func requestLocation() {
        guard isAuthorized else {
            requestPermission()
            return
        }
        manager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task { @MainActor in
            self.userLatitude = location.coordinate.latitude
            self.userLongitude = location.coordinate.longitude
            self.locationError = nil
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.locationError = error.localizedDescription
            print("Location error: \(error.localizedDescription)")
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationStatus = manager.authorizationStatus
            if self.isAuthorized {
                manager.requestLocation()
            }
        }
    }
}
