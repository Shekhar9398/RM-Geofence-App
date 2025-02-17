import SwiftUI
import GoogleMaps
import CoreLocation

// MARK: - DrawGeofenceView
struct DrawGeofenceView: View {
    @State private var coordinates: [CLLocationCoordinate2D] = []
    @State private var isDrawing: Bool = false
    @State private var geofenceName: String = ""
    @State private var geofenceColor: UIColor = .blue
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Draw a custom geofence area")
                .foregroundColor(.orange)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            // Geofence Name TextField
            TextField("Enter Geofence Name", text: $geofenceName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)

            // Drawing Map View
            DrawingMapView(coordinates: $coordinates, isDrawingEnabled: $isDrawing)
                .edgesIgnoringSafeArea(.all) // Full-screen map
                .padding()

            // Start/Stop Drawing Button
            Button(action: {
                isDrawing.toggle()
            }) {
                Text(isDrawing ? "Stop Drawing" : "Start Drawing")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(isDrawing ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .bold()
            }
            .padding(.horizontal, 20)

            // Clear Drawing Button
            if !coordinates.isEmpty {
                Button(action: {
                    coordinates.removeAll()
                    geofenceName = ""
                    isDrawing = false
                }) {
                    Text("Clear Geofence")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .bold()
                }
                .padding(.horizontal, 20)
            }

            Spacer()
        }
        .navigationTitle("Custom Geofence Drawing")
    }
}

struct DrawGeofenceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DrawGeofenceView()
        }
    }
}
