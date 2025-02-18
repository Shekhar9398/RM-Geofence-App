import SwiftUI

struct MonitorGeofenceView: View {
    @State private var geofences: [Geofence] = []  // Now using Geofence struct
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationView {
            VStack {
                if geofences.isEmpty {
                    Text("No geofences to monitor.")
                        .font(.headline)
                        .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(geofences, id: \.id) { geofence in
                            NavigationLink(
                                destination: GeofenceMapView(geofence: geofence)
                            ) {
                                Text(geofence.title)
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
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
        }
    }
    
    // MARK: - Load Geofences
    private func loadGeofences() {
        geofences = GeofenceManager.shared.getGeofences()
    }
}
