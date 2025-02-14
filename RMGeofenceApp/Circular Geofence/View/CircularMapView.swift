import SwiftUI
import GoogleMaps

struct CircularMapView: UIViewRepresentable {
    var centerCoordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var title: String

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(
            withLatitude: centerCoordinate.latitude,
            longitude: centerCoordinate.longitude,
            zoom: 14
        )
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()

        ///Mark:- create geofence circle
        let circle = GMSCircle(position: centerCoordinate, radius: radius)
        circle.fillColor = UIColor.red.withAlphaComponent(0.1)
        circle.strokeColor = .blue
        circle.strokeWidth = 2
        circle.map = mapView

        ///Mark:- Add a marker at the center of the circle with the title
        let marker = GMSMarker(position: centerCoordinate)
        marker.title = title
        marker.map = mapView
    }
}
