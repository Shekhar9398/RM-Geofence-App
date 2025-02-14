import SwiftUI
import GoogleMaps
import CoreLocation

// MARK: - CoordinateMapView
struct CoordinateMapView: UIViewRepresentable {
    var coordinates: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> GMSMapView {
        // Center the map on the first coordinate (or default to (0,0) if empty)
        let initialCoordinate = coordinates.first ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let camera = GMSCameraPosition.camera(
            withLatitude: initialCoordinate.latitude,
            longitude: initialCoordinate.longitude,
            zoom: 12
        )
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        // Clear previous overlays
        mapView.clear()
        
        // If no coordinates exist, don't draw a polygon.
        guard !coordinates.isEmpty else { return }
        
        // Create a mutable path and add each coordinate
        let path = GMSMutablePath()
        for coordinate in coordinates {
            path.add(coordinate)
        }
        
        ///Mark:- Create a polygon from the path and set its appearance
        let polygon = GMSPolygon(path: path)
        polygon.fillColor = UIColor.getRandomColor().withAlphaComponent(0.4)
        polygon.strokeColor = .black
        polygon.strokeWidth = 2
        polygon.map = mapView
        
    }
}

