import SwiftUI
import CoreLocation

struct CreateGeofenceView: View {
    @State private var title = "Job Site A"
    @State private var latitude = "37.7749"
    @State private var longitude = "-122.4194"
    @State private var radius = "500"
    
    var body: some View {
        VStack {
            TextField("Enter Geofence Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save Geofence") {
                if let lat = Double(latitude),
                   let lon = Double(longitude),
                   let rad = Double(radius) {
                    GeofenceManager.shared.saveGeofence(
                        title: title,
                        coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                        radius: rad
                    )
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
