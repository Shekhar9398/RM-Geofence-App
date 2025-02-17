import SwiftUI
import GoogleMaps
import CoreLocation

struct MonitorGeofenceView: View {
    @State private var geofences: [[String: String]] = []
    
    var body: some View {
        VStack {
            if geofences.isEmpty {
                Text("No geofences to monitor.")
                    .font(.headline)
                    .padding()
            } else {
                List(geofences, id: \.["title"]) { geofence in
                    if let latStr = geofence["latitude"], let lonStr = geofence["longitude"], let radStr = geofence["radius"],
                       let lat = Double(latStr), let lon = Double(lonStr), let rad = Double(radStr) {
                        
                        CircularMapView(
                            centerCoordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                            radius: rad,
                            title: geofence["title"] ?? "Geofence"
                        )
                        .frame(height: 300) // Ensures the map is visible
                        .cornerRadius(12)
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            loadGeofences()
            NotificationCenter.default.addObserver(forName: NSNotification.Name("GeofenceSaved"), object: nil, queue: .main) { _ in
                loadGeofences()
            }
        }
    }
    
    private func loadGeofences() {
        geofences = GeofenceManager.shared.loadGeofences()
    }
}
