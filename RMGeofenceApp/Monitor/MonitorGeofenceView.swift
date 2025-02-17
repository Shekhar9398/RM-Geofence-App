import SwiftUI
import CoreLocation

// MonitorGeofenceView is responsible for displaying and monitoring the geofences
struct MonitorGeofenceView: View {
    @State private var geofences: [[String: String]] = []
    
    var body: some View {
        VStack {
            // Display a message if there are no geofences
            if geofences.isEmpty {
                Text("No geofences to monitor.")
                    .font(.headline)
                    .padding()
            } else {
                // List all geofences and display each one with its associated circular map view
                List(geofences, id: \.["title"]) { geofence in
                    if let latStr = geofence["latitude"], let lonStr = geofence["longitude"], let radStr = geofence["radius"],
                       let lat = Double(latStr), let lon = Double(lonStr), let rad = Double(radStr) {
                        
                        MonitorCircularView(
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
            
            // Button to clear all geofences
            Button(action: {
                GeofenceManager.shared.clearAllGeofences()
                loadGeofences() // Refresh the geofences after clearing
            }) {
                Text("Clear All Geofences")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
                    .background(Capsule().stroke(Color.red, lineWidth: 2))
            }
            .padding(.top)
        }
        .onAppear {
            loadGeofences()
            NotificationCenter.default.addObserver(forName: NSNotification.Name("GeofenceSaved"), object: nil, queue: .main) { _ in
                loadGeofences()
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("GeofencesCleared"), object: nil, queue: .main) { _ in
                loadGeofences() // Refresh geofences when they are cleared
            }
        }
    }
    
    // Load the geofences from the GeofenceManager
    private func loadGeofences() {
        geofences = GeofenceManager.shared.loadGeofences()
    }
}
