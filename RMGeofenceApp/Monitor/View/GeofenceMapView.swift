import SwiftUI
import CoreLocation

struct GeofenceMapView: View {
    var geofence: Geofence
    
    var body: some View {
        VStack {
            if geofence.type == "circular" {
                if let lat = geofence.latitude, let lon = geofence.longitude, let radius = geofence.radius {
                    GoogleMapView(
                        center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                        radius: radius,
                        title: geofence.title
                    )
                }
            } else if geofence.type == "coordinate", let coordinates = geofence.coordinates {
                GoogleMapView(
                    coordinates: coordinates,
                    title: geofence.title
                )
            }
        }
        .navigationTitle(geofence.title)
    }
}
