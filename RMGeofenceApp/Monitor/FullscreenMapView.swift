import SwiftUI
import GoogleMaps
import CoreLocation

// FullscreenMapView displays the selected geofence on Google Map in full screen
struct FullscreenMapView: View {
    var centerCoordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .bold()
                .padding()

            GoogleMapView(center: centerCoordinate, radius: radius)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
