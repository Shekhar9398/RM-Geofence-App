import SwiftUI

struct CircularGeofenceView: View {
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var radius = ""

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

                // Radius
                VStack(alignment: .leading, spacing: 5) {
                    Text("Set the Radius for geofence")
                        .foregroundColor(.gray)
                        .bold()

                    Text("Radius")
                        .foregroundColor(.black)
                        .bold()

                    TextField("Enter Radius", text: $radius)
                        .textFieldStyle(RoundedTextFieldStyle())
                }

                // Save Geofence Button
                Button(action: {
                    // Save geofence action
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
        }
        .padding()
    }
}

#Preview {
    CircularGeofenceView()
}
