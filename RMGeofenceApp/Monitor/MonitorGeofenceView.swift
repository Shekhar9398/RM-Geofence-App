import SwiftUI
import CoreLocation

struct MonitorGeofenceView: View {
    @State private var geofences: [[String: String]] = []
    @State private var selectedGeofence: [String: String]? = nil
    @State private var isMapFullScreen = false
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationView {
            VStack {
                if geofences.isEmpty {
                    Text("No geofences to monitor.")
                        .font(.headline)
                        .padding()
                } else {
                    // Grid layout for geofences
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(geofences, id: \.["title"]) { geofence in
                            if let title = geofence["title"] {
                                // Geofence name as a clickable button
                                Button(action: {
                                    self.selectedGeofence = geofence
                                    self.isMapFullScreen = true
                                }) {
                                    Text(title)
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Monitor Geofences")
            .onAppear {
                loadGeofences()
                NotificationCenter.default.addObserver(forName: NSNotification.Name("GeofenceSaved"), object: nil, queue: .main) { _ in
                    loadGeofences()
                }
            }
            .sheet(isPresented: $isMapFullScreen) {
                if let geofence = selectedGeofence,
                   let latStr = geofence["latitude"], let lonStr = geofence["longitude"], let radStr = geofence["radius"],
                   let lat = Double(latStr), let lon = Double(lonStr), let rad = Double(radStr) {
                    // Fullscreen map view when a geofence is selected
                    FullscreenMapView(centerCoordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), radius: rad, title: geofence["title"] ?? "Geofence")
                }
            }
        }
    }
    
    // Load the geofences from the GeofenceManager
    private func loadGeofences() {
        // Load geofences from GeofenceManager (whether coordinate or circular)
        geofences = GeofenceManager.shared.loadGeofences()
    }
}

struct MonitorGeofenceView_Previews: PreviewProvider {
    static var previews: some View {
        MonitorGeofenceView()
    }
}
