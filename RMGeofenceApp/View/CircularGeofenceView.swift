import SwiftUI
import CoreLocation

struct CircularGeofenceView: View {
    @State private var latitude = "18.516726"
    @State private var longitude = "73.856255"
    @State private var radius = "800"
    @State private var showMap = false
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var geofenceRadius: CLLocationDistance = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Please add a center and radius for the geofence")
                .foregroundColor(.blue)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            VStack(alignment: .leading, spacing: 15) {
                Text("Set the center for geofence")
                    .foregroundColor(.gray)
                    .bold()

                // Latitude
                VStack(alignment: .leading, spacing: 5) {
                    Text("Latitude")
                        .foregroundColor(.black)
                        .bold()

                    TextField("Enter Latitude", text: $latitude)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }

                // Longitude
                VStack(alignment: .leading, spacing: 5) {
                    Text("Longitude")
                        .foregroundColor(.black)
                        .bold()

                    TextField("Enter Longitude", text: $longitude)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }

                // Radius
                VStack(alignment: .leading, spacing: 5) {
                    Text("Set the Radius for geofence")
                        .foregroundColor(.gray)
                        .bold()

                    Text("Radius (meters)")
                        .foregroundColor(.black)
                        .bold()

                    TextField("Enter Radius", text: $radius)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }

                // Save Geofence Button
                Button(action: {
                    if let lat = Double(latitude), let lon = Double(longitude), let rad = Double(radius) {
                        centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        geofenceRadius = rad
                        showMap = true
                    }
                }) {
                    Text("Create Geofence")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .bold()
                }
                .padding(.top, 10)
            }
            .padding()
            .frame(maxWidth: 350)

            if showMap {
                CircularMapView(centerCoordinate: centerCoordinate, radius: geofenceRadius)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .padding()
    }
}
