import SwiftUI
import GoogleMaps
import CoreLocation

struct GoogleMapView: UIViewRepresentable {
    var center: CLLocationCoordinate2D?
    var radius: CLLocationDistance?
    var coordinates: [Coordinate]?
    var title: String?
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(frame: .zero)
        
        if let center = center, let radius = radius {
            // Display circular geofence
            let camera = GMSCameraPosition.camera(withLatitude: center.latitude, longitude: center.longitude, zoom: 14)
            mapView.camera = camera
            
            let circle = createCircleView(center: center, radius: radius)
            circle.map = mapView
            
            if let title = title {
                let marker = GMSMarker(position: center)
                marker.title = title
                marker.map = mapView
            }
        } else if let coordinates = coordinates, !coordinates.isEmpty {
            // Display polygon geofence
            let path = GMSMutablePath()
            for coordinate in coordinates {
                path.add(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
            }
            
            let polygon = GMSPolygon(path: path)
            polygon.fillColor = UIColor.red.withAlphaComponent(0.3)
            polygon.strokeColor = .red
            polygon.strokeWidth = 2.0
            polygon.map = mapView
            
            let bounds = GMSCoordinateBounds(path: path)
            mapView.moveCamera(GMSCameraUpdate.fit(bounds, withPadding: 50))
        }
        
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

