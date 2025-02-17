import Foundation
import CoreLocation

class CoordinateManager {
    
    private static let coordinatesKey = "savedCoordinates"
    
    // Save coordinates to UserDefaults
    static func saveCoordinates(_ coordinates: [Coordinate]) {
        let coordinateData = coordinates.map { ["latitude": $0.latitude, "longitude": $0.longitude] }
        UserDefaults.standard.set(coordinateData, forKey: coordinatesKey)
    }
    
    // Load coordinates from UserDefaults
    static func loadCoordinates() -> [Coordinate] {
        guard let savedCoordinates = UserDefaults.standard.array(forKey: coordinatesKey) as? [[String: Double]] else {
            return []
        }
        return savedCoordinates.compactMap { dict in
            guard let latitude = dict["latitude"], let longitude = dict["longitude"] else { return nil }
            return Coordinate(latitude: latitude, longitude: longitude)
        }
    }
    
    // Remove all saved coordinates from UserDefaults
    static func clearCoordinates() {
        UserDefaults.standard.removeObject(forKey: coordinatesKey)
    }
    
    // Remove a specific coordinate from UserDefaults by its index
    static func removeCoordinate(at index: Int, from coordinates: inout [Coordinate]) {
        coordinates.remove(at: index)
        saveCoordinates(coordinates)
    }
}

