import SwiftUI
import GoogleMaps
import CoreLocation

// MARK: - DrawGeofenceView
struct DrawGeofenceView: View {
    @State private var coordinates: [CLLocationCoordinate2D] = []
    @State private var isDrawing: Bool = false
    @State private var geofenceName: String = ""
    @State private var geofenceColor: UIColor = .blue
    @State private var showSaveButton: Bool = false  // To control visibility of the save button
    @State private var showAlert: Bool = false  // To show success alert
    
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
                showSaveButton = isDrawing // Show save button when drawing starts
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
                    showSaveButton = false
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

            // Save Geofence Button (only visible when drawing is enabled)
            if showSaveButton {
                Button(action: {
                    saveGeofence()
                }) {
                    Text("Save Geofence")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .bold()
                }
                .padding(.horizontal, 20)
            }

            Spacer()
        }
        .navigationTitle("Custom Geofence Drawing")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Geofence Added"),
                message: Text("The geofence has been added successfully to the monitor list."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Save Geofence
    private func saveGeofence() {
        guard !coordinates.isEmpty, !geofenceName.isEmpty else { return }

        // Convert CLLocationCoordinate2D to Coordinate model
        let coordinateObjects = coordinates.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) }

        // Save geofence using GeofenceManager
        GeofenceManager.shared.saveCoordinateGeofence(title: geofenceName, coordinates: coordinateObjects)
        
        // Show success alert
        showAlert = true
        
        // Clear drawing after saving
        coordinates.removeAll()
        geofenceName = ""
        isDrawing = false
        showSaveButton = false
    }
}

struct DrawGeofenceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DrawGeofenceView()
        }
    }
}
