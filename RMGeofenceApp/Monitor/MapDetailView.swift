import SwiftUI
import GoogleMaps
import CoreLocation

struct MapDetailView: View {
    let geofence: [String: String]
    @Binding var showMap: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Header with Back button
            HStack {
                Button(action: {
                    showMap = false
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                Spacer()
            }
            .padding()

            // Map view for the selected geofence
            if let latStr = geofence["latitude"],
               let lonStr = geofence["longitude"],
               let radStr = geofence["radius"],
               let lat = Double(latStr),
               let lon = Double(lonStr),
               let rad = Double(radStr) {
                CircularMapView(
                    centerCoordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                    radius: rad,
                    title: geofence["title"] ?? "Geofence"
                )
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
