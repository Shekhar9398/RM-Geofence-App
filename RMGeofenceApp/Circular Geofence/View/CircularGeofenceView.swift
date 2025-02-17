import SwiftUI
import CoreLocation

struct CircularGeofenceView: View {
    @State private var latitude = "18.516726"
    @State private var longitude = "73.856255"
    @State private var radius = "1500"
    @State private var title = "My Geofence"
    @State private var showMap = false
    @State private var showSaveButton = false
    @State private var showFullScreenMap = false
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var geofenceRadius: CLLocationDistance = 0
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Please add a center and radius for the geofence")
                .foregroundColor(.blue)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Set the center for geofence")
                    .foregroundColor(.gray)
                    .bold()
                
                Text("Name")
                    .foregroundColor(.black)
                    .bold()
                
                TextField("Enter Name", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Latitude")
                    .foregroundColor(.black)
                    .bold()
                
                TextField("Enter Latitude", text: $latitude)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Longitude")
                    .foregroundColor(.black)
                    .bold()
                
                TextField("Enter Longitude", text: $longitude)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Radius (meters)")
                    .foregroundColor(.black)
                    .bold()
                
                TextField("Enter Radius", text: $radius)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if let lat = Double(latitude), let lon = Double(longitude), let rad = Double(radius) {
                        centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        geofenceRadius = rad
                        showMap = true
                        showSaveButton = true
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
                
                if showSaveButton {
                    Button(action: saveGeofence) {
                        Text("Save Geofence")
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .bold()
                    }
                    .padding(.top, 10)
                }
            }
            .padding()
            .frame(maxWidth: 350)
            
            if showMap {
                ZStack {
                    CircularMapView(centerCoordinate: centerCoordinate, radius: geofenceRadius, title: title)
                        .frame(height: 300)
                        .cornerRadius(10)
                        .padding()
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                showFullScreenMap = true
                            }) {
                                Text("FullScreen")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text("Your geofence has been added to Monitor View successfully."), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: $showFullScreenMap) {
            FullScreenMapView(centerCoordinate: centerCoordinate, radius: geofenceRadius, title: title)
        }
    }
    
    private func saveGeofence() {
        let geofence = [
            "title": title,
            "latitude": latitude,
            "longitude": longitude,
            "radius": radius
        ]
        
        var savedGeofences = UserDefaults.standard.array(forKey: "geofences") as? [[String: String]] ?? []
        savedGeofences.append(geofence)
        UserDefaults.standard.set(savedGeofences, forKey: "geofences")
        
        // Notify MonitorGeofenceView
        NotificationCenter.default.post(name: NSNotification.Name("GeofenceSaved"), object: nil)
        showAlert = true
    }
}
