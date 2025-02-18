import Foundation
import CoreLocation

struct Geofence: Hashable {
    var id: UUID
    var title: String
    var type: String
    var latitude: Double?
    var longitude: Double?
    var radius: Double?
    var coordinates: [Coordinate]?

    // Conform to Hashable
    static func ==(lhs: Geofence, rhs: Geofence) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
