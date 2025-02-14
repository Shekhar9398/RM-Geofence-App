import SwiftUI
import GoogleMaps
import CoreLocation

struct CoordinateGeofenceView: View {
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var coordinates: [Coordinate] = []
    @State private var showMapView = false  // Triggers navigation to the map view

    var body: some View {
            VStack(spacing: 20) {
                Text("Enter Latitudes and Longitudes")
                    .foregroundColor(.green)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Input fields for latitude and longitude
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Latitude", text: $latitude)
                        .textFieldStyle(RoundedTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
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
                            Button(action: { coordinates.removeAll() }) {
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
        }
    
    // Adds a new coordinate if valid values are provided
    private func addCoordinate() {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else { return }
        let newCoordinate = Coordinate(latitude: lat, longitude: lon)
        coordinates.append(newCoordinate)
        latitude = ""
        longitude = ""
    }
    
    // Removes a coordinate at the given index
    private func removeCoordinate(at index: Int) {
        coordinates.remove(at: index)
    }
}

#Preview {
    CoordinateGeofenceView()
}
