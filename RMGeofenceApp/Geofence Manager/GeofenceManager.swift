import Foundation
import CoreLocation

class GeofenceManager {
    static let shared = GeofenceManager()
    
    private init() {}
    
    // Save a geofence to UserDefaults
    func saveGeofence(title: String, coordinate: CLLocationCoordinate2D, radius: Double, type: String) {
        var geofences = loadGeofences()
        
        let newGeofence: [String: Any] = [
            "id": UUID().uuidString,
            "title": title,
            "type": type,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            "radius": radius
        ]
        
        geofences.append(newGeofence)
        UserDefaults.standard.set(geofences, forKey: "geofences")
        NotificationCenter.default.post(name: NSNotification.Name("GeofenceSaved"), object: nil)
    }

    // Save a coordinate-based geofence (polygon)
    func saveCoordinateGeofence(title: String, coordinates: [Coordinate]) {
        let geofence: [String: Any] = [
            "id": UUID().uuidString,
            "title": title,
            "type": "coordinate",
            "coordinates": coordinates.map { ["latitude": $0.latitude, "longitude": $0.longitude] }
        ]
        var geofences = loadGeofences()
        geofences.append(geofence)
        UserDefaults.standard.set(geofences, forKey: "geofences")
        NotificationCenter.default.post(name: NSNotification.Name("GeofenceSaved"), object: nil)
    }

    // Load geofences from UserDefaults
    func loadGeofences() -> [[String: Any]] {
        return UserDefaults.standard.array(forKey: "geofences") as? [[String: Any]] ?? []
    }

    // Clear all saved geofences from UserDefaults
    func clearAllGeofences() {
        UserDefaults.standard.removeObject(forKey: "geofences")
        NotificationCenter.default.post(name: NSNotification.Name("GeofencesCleared"), object: nil)
    }
    
    // Convert stored geofences into Geofence objects
    func getGeofences() -> [Geofence] {
        let storedGeofences = loadGeofences()
        return storedGeofences.compactMap { geofenceDict in
            guard let title = geofenceDict["title"] as? String,
                  let type = geofenceDict["type"] as? String else {
                return nil
            }
            
            let id = UUID(uuidString: geofenceDict["id"] as? String ?? "") ?? UUID()
            var latitude: Double?
            var longitude: Double?
            var radius: Double?
            var coordinates: [Coordinate]?
            
            if type == "circular" {
                latitude = geofenceDict["latitude"] as? Double
                longitude = geofenceDict["longitude"] as? Double
                radius = geofenceDict["radius"] as? Double
            } else if type == "coordinate" {
                if let coordinateData = geofenceDict["coordinates"] as? [[String: Double]] {
                    coordinates = coordinateData.compactMap { dict in
                        guard let lat = dict["latitude"], let lon = dict["longitude"] else { return nil }
                        return Coordinate(latitude: lat, longitude: lon)
                    }
                }
            }
            
            return Geofence(id: id, title: title, type: type, latitude: latitude, longitude: longitude, radius: radius, coordinates: coordinates)
        }
    }
    
    // Delete a specific geofence by id
    func deleteGeofence(_ geofence: Geofence) {
        var geofences = loadGeofences()
        if let index = geofences.firstIndex(where: { ($0["id"] as? String) == geofence.id.uuidString }) {
            geofences.remove(at: index)
            UserDefaults.standard.set(geofences, forKey: "geofences")
            NotificationCenter.default.post(name: NSNotification.Name("GeofenceDeleted"), object: nil)
        }
    }
}
