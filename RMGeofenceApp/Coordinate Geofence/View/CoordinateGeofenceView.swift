import SwiftUI
import CoreLocation

struct CoordinateGeofenceView: View {
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var coordinates: [Coordinate] = []
    @State private var showMapView = false  // Triggers navigation to the map view
    @State private var showSaveButton = false  // To control visibility of "Save Geofence" button
    @State private var showAlert = false  // To control the alert visibility
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Latitudes and Longitudes")
                .foregroundColor(.green)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Latitude")
                    .foregroundColor(.black)
                    .bold()
                
                TextField("Latitude", text: $latitude)
                    .textFieldStyle(RoundedTextFieldStyle())
                    .keyboardType(.decimalPad)
                
                Text("Longitude")
                    .foregroundColor(.black)
                    .bold()
                
                TextField("Longitude", text: $longitude)
                    .textFieldStyle(RoundedTextFieldStyle())
                    .keyboardType(.decimalPad)
                
                HStack {
                    Button(action: addCoordinate) {
                        Text("Add +")
                            .frame(maxWidth: 150, minHeight: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .bold()
                    }
                    
                    if !coordinates.isEmpty {
                        Button(action: { clearAllCoordinates() }) {
                            Text("Clear All")
                                .frame(maxWidth: 150, minHeight: 50)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .bold()
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: 350)
            
            // List of entered coordinates with labels and a remove button
            if !coordinates.isEmpty {
                List {
                    ForEach(Array(coordinates.enumerated()), id: \.element.id) { index, coordinate in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Coordinate \(index + 1)")
                                    .font(.headline)
                                Text("Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button(action: { removeCoordinate(at: index) }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
            
            // Create Geofence Button
            Button(action: {
                showMapView = true
                showSaveButton = true  // Show the save geofence button after create geofence
            }) {
                Text("Create Geofence")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(coordinates.count < 3 ? Color.blue.opacity(0.5) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .bold()
            }
            .padding(.horizontal, 20)
            .disabled(coordinates.count < 3)
            
            // Save Geofence Button (only visible after Create Geofence is clicked)
            if showSaveButton {
                Button(action: saveGeofence) {
                    Text("Save Geofence")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .bold()
                }
                .padding(.horizontal, 20)
            }
            
            // Hidden NavigationLink to push the CoordinateMapView
            NavigationLink(
                destination: CoordinateMapView(coordinates: coordinates.map {
                    CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                }),
                isActive: $showMapView,
                label: { EmptyView() }
            )
        }
        .navigationTitle("Geofence Coordinates")
        .onAppear {
            loadCoordinates()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Success"),
                message: Text("Your geofence has been added to Monitor View successfully."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // Adds a new coordinate if valid values are provided
    private func addCoordinate() {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else { return }
        let newCoordinate = Coordinate(latitude: lat, longitude: lon)
        coordinates.append(newCoordinate)
        latitude = ""
        longitude = ""
        saveCoordinates()
    }
    
    // Removes a coordinate at the given index
    private func removeCoordinate(at index: Int) {
        CoordinateManager.removeCoordinate(at: index, from: &coordinates)
    }
    
    // Clears all coordinates
    private func clearAllCoordinates() {
        coordinates.removeAll()
        CoordinateManager.clearCoordinates()
    }
    
    // Saves coordinates to UserDefaults
    private func saveCoordinates() {
        CoordinateManager.saveCoordinates(coordinates)
    }
    
    // Loads coordinates from UserDefaults
    private func loadCoordinates() {
        coordinates = CoordinateManager.loadCoordinates()
    }
    
    // Save the geofence when the button is clicked
    private func saveGeofence() {
        // Save geofence data, you can add additional fields if needed
        let geofence = [
            "title": "Geofence at \(coordinates.first?.latitude ?? 0), \(coordinates.first?.longitude ?? 0)",
            "latitude": "\(coordinates.first?.latitude ?? 0)",
            "longitude": "\(coordinates.first?.longitude ?? 0)",
            "radius": "500" // Default radius for coordinate-based geofence
        ]
        
        // Optionally, save geofence to UserDefaults or to any other persistent storage
        GeofenceManager.shared.saveGeofence(title: geofence["title"] ?? "Geofence",
                                             coordinate: CLLocationCoordinate2D(latitude: coordinates.first?.latitude ?? 0,
                                                                                 longitude: coordinates.first?.longitude ?? 0),
                                             radius: 500) // Default radius for coordinate geofence
        
        // Show alert to notify user of success
        showAlert = true
        
        // Clear the list of coordinates after saving
        coordinates.removeAll()
        showSaveButton = false
    }
}

struct CoordinateGeofenceView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinateGeofenceView()
    }
}
