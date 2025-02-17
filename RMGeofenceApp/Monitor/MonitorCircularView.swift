import SwiftUI
import GoogleMaps
import CoreLocation

// CircularMapView is a custom SwiftUI view that shows a circle on Google Maps
struct MonitorCircularView: UIViewRepresentable {
    var centerCoordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var title: String
    
    func makeUIView(context: Context) -> GMSMapView {
        // Set initial camera position (zoomed in on the center coordinate)
        let camera = GMSCameraPosition.camera(withLatitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude, zoom: 14)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        
        // Create and add circle to the map
        let circle = createCircleView(center: centerCoordinate, radius: radius)
        circle.map = mapView
        
        // Optionally, you can add a marker for the title or any additional information
        let marker = GMSMarker(position: centerCoordinate)
        marker.title = title
        marker.map = mapView
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Update the map if needed.
    }
    
    // Function to create a circle on the map
    private func createCircleView(center: CLLocationCoordinate2D, radius: CLLocationDistance) -> GMSCircle {
        let circle = GMSCircle(position: center, radius: radius)
        
        // Set the circle's styling (e.g., color and stroke width)
        circle.fillColor = UIColor.blue.withAlphaComponent(0.3)  // Blue color with transparency
        circle.strokeColor = .green
        circle.strokeWidth = 2.0
        
        return circle
    }
}
