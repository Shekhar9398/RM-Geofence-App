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
        
        // Create a polygon from the path and set its appearance
        let polygon = GMSPolygon(path: path)
        polygon.fillColor = UIColor.getRandomColor().withAlphaComponent(0.4)
        polygon.strokeColor = .black
        polygon.strokeWidth = 2
        polygon.map = mapView
        
        // Optionally, animate the camera to the first coordinate
        if let firstCoordinate = coordinates.first {
            let camera = GMSCameraPosition.camera(
                withLatitude: firstCoordinate.latitude,
                longitude: firstCoordinate.longitude,
                zoom: 12
            )
            mapView.animate(to: camera)
        }
    }
}

// MARK: - Preview Example
struct CoordinateMapView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinateMapView(coordinates: [
            CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4294),
            CLLocationCoordinate2D(latitude: 37.7649, longitude: -122.4094)
        ])
        .frame(height: 300)
    }
}
