import SwiftUI
import GoogleMaps

struct CircularMapView: UIViewRepresentable {
        var centerCoordinate: CLLocationCoordinate2D
        var radius: CLLocationDistance

        func makeUIView(context: Context) -> GMSMapView {
            let camera = GMSCameraPosition.camera(withLatitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude, zoom: 12)
            let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
            return mapView
        }

        func updateUIView(_ mapView: GMSMapView, context: Context) {
            mapView.clear()

            // Add the geofence circle
            let circle = GMSCircle(position: centerCoordinate, radius: radius)
            circle.fillColor = UIColor.blue.withAlphaComponent(0.1)
            circle.strokeColor = .blue
            circle.strokeWidth = 2
            circle.map = mapView
   }
}
