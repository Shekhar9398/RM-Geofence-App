import SwiftUI
import GoogleMaps
import CoreLocation

struct GoogleMapView: UIViewRepresentable {
    var center: CLLocationCoordinate2D
    var radius: CLLocationDistance
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: center.latitude, longitude: center.longitude, zoom: 14)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        
        // Create and add circle to the map
        let circle = createCircleView(center: center, radius: radius)
        circle.map = mapView
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {}
    
    private func createCircleView(center: CLLocationCoordinate2D, radius: CLLocationDistance) -> GMSCircle {
        let circle = GMSCircle(position: center, radius: radius)
        circle.fillColor = UIColor.blue.withAlphaComponent(0.3)
        circle.strokeColor = .green
        circle.strokeWidth = 2.0
        return circle
    }
}
