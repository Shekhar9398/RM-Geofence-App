import SwiftUI
import CoreLocation

struct CoordinateGeofenceView: View {
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var title = ""
    @State private var coordinates: [Coordinate] = []
    @State private var showMapView = false
    @State private var showSaveButton = false
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Latitudes and Longitudes")
                .foregroundColor(.green)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Name")
                    .foregroundColor(.black)
                    .bold()
                
                TextField("Enter Geofence Name", text: $title)
                    .textFieldStyle(RoundedTextFieldStyle())
                    .keyboardType(.decimalPad)
                
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
            
            // List of entered coordinates
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
                showSaveButton = true
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
            
            // Save Geofence Button
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
    
    private func addCoordinate() {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else { return }
        let newCoordinate = Coordinate(latitude: lat, longitude: lon)
        coordinates.append(newCoordinate)
        latitude = ""
        longitude = ""
        saveCoordinates()
    }
    
    private func removeCoordinate(at index: Int) {
        CoordinateManager.removeCoordinate(at: index, from: &coordinates)
    }
    
    private func clearAllCoordinates() {
        coordinates.removeAll()
        CoordinateManager.clearCoordinates()
    }
    
    private func saveCoordinates() {
        CoordinateManager.saveCoordinates(coordinates)
    }
    
    private func loadCoordinates() {
        coordinates = CoordinateManager.loadCoordinates()
    }
    
    private func saveGeofence() {
        let geofence = Geofence(
            id: UUID(),
            title: title,
            type: "coordinate",
            latitude: coordinates.first?.latitude,
            longitude: coordinates.first?.longitude,
            radius: 500,
            coordinates: coordinates
        )
        
        GeofenceManager.shared.saveCoordinateGeofence(title: geofence.title, coordinates: coordinates)
        
        showAlert = true
        
        coordinates.removeAll()
        showSaveButton = false
    }
}

struct CoordinateGeofenceView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinateGeofenceView()
    }
}
