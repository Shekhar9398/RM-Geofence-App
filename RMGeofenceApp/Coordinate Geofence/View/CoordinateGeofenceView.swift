
import SwiftUI

struct CoordinateGeofenceView: View {
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var total = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("please Enter Lattitudes and Longitudes for the geofence here")
                .foregroundColor(.green)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            VStack(alignment: .leading, spacing: 15) {
                // Latitude
                VStack(alignment: .leading, spacing: 5) {
                    Text("Latitude")
                        .foregroundColor(.black)
                        .bold()

                    TextField("Enter Latitude", text: $latitude)
                        .textFieldStyle(RoundedTextFieldStyle())
                }

                // Longitude
                VStack(alignment: .leading, spacing: 5) {
                    Text("Longitude")
                        .foregroundColor(.black)
                        .bold()

                    TextField("Enter Longitude", text: $longitude)
                        .textFieldStyle(RoundedTextFieldStyle())
                }
                
                    Text("Total added Coordinates - \(total)")
                    .padding()

                // Add more Geofences Button
                Button(action: {
                    total += 1
                }) {
                    Text("Add +")
                        .frame(maxWidth: 150, minHeight: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .bold()
                }
                .padding(.top, 10)
                
                // Create Geofence Button
                Button(action: {
                   total = 0
                }) {
                    Text("Create Geofence")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .bold()
                }
                .padding(.top, 10)
                
            }
            .padding()
            .frame(maxWidth: 350)
        }
        .padding()
    }
}

#Preview {
    CoordinateGeofenceView()
}
