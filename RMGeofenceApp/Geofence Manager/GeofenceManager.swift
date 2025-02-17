import Foundation
import CoreLocation

class GeofenceManager {
    static let shared = GeofenceManager()
    
    private init() {}

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

    func loadGeofences() -> [[String: String]] {
        return UserDefaults.standard.array(forKey: "geofences") as? [[String: String]] ?? []
    }
}
