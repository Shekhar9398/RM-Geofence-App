import Foundation
import CoreLocation

class GeofenceManager {
    static let shared = GeofenceManager()
    
    private init() {}
    
    // Save a geofence to UserDefaults
    func saveGeofence(title: String, coordinate: CLLocationCoordinate2D, radius: Double) {
        var geofences = loadGeofences()
        let newGeofence: [String: String] = [
            "title": title,
            "latitude": "\(coordinate.latitude)",
            "longitude": "\(coordinate.longitude)",
            "radius": "\(radius)"
        ]
        geofences.append(newGeofence)
        UserDefaults.standard.set(geofences, forKey: "geofences")
        NotificationCenter.default.post(name: NSNotification.Name("GeofenceSaved"), object: nil)
    }

    // Load geofences from UserDefaults
    func loadGeofences() -> [[String: String]] {
        return UserDefaults.standard.array(forKey: "geofences") as? [[String: String]] ?? []
    }

    // Clear all saved geofences from UserDefaults
    func clearAllGeofences() {
        UserDefaults.standard.removeObject(forKey: "geofences")
        NotificationCenter.default.post(name: NSNotification.Name("GeofencesCleared"), object: nil)
    }
}
