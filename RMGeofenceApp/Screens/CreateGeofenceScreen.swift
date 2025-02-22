import SwiftUI
import CoreLocation

struct CreateGeofenceScreen: View {
    ///Mark:- CreateGeofenceView - No need of NavigationView (aleready present at HomeScreenView)
    var body: some View {
            VStack(spacing: 20) {
                Text("Select one of the options to create a Geofence area")
                    .font(.headline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .bold()
                    .padding(.horizontal, 20)
                
                VStack(spacing: 15) {
                    ///Mark:- Circular Geofence Button
                    NavigationLink(destination: CircularGeofenceView()) {
                        VStack {
                            Image(systemName: "circle.dotted.circle") // More relevant icon
                                .font(.system(size: 35))
                            
                            Text("Circular")
                        }
                    }
                    .buttonStyle(RoundedButtonStyle(backgroundColor: .blue))
                    
                    ///Mark:-  Coordinate Geofence Button
                    NavigationLink(destination: CoordinateGeofenceView()) {
                        VStack {
                            Image(systemName: "map")
                                .font(.system(size: 35))
                            
                            Text("Coordinates")
                        }
                    }
                    .buttonStyle(RoundedButtonStyle(backgroundColor: .green))
                    
                    ///Mark:- Draw Geofence Button
                    NavigationLink(destination: DrawGeofenceView()) {
                        VStack {
                            Image(systemName: "pencil.and.outline")
                                .font(.system(size: 35))
                            
                            Text("Draw")
                        }
                    }
                    .buttonStyle(RoundedButtonStyle(backgroundColor: .orange))
                }
                .padding(.top, 10)
            }
            .padding()
            .navigationTitle("Create Geofence")
        }
    }

