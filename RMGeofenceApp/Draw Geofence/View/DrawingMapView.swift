import SwiftUI
import GoogleMaps

struct DrawingMapView: UIViewRepresentable {
    @Binding var coordinates: [CLLocationCoordinate2D]
    @Binding var isDrawingEnabled: Bool

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let initialCoordinate = coordinates.first ?? CLLocationCoordinate2D(latitude: 18.516726, longitude: 73.856255)
        let camera = GMSCameraPosition.camera(withLatitude: initialCoordinate.latitude,
                                              longitude: initialCoordinate.longitude,
                                              zoom: 12)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        context.coordinator.mapView = mapView

        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePanGesture(_:)))
        panGesture.maximumNumberOfTouches = 1
        mapView.addGestureRecognizer(panGesture)

        updateMapGestures(mapView, isDrawingEnabled)

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        updateMapGestures(uiView, isDrawingEnabled)

        guard coordinates.count >= 3 else { return }
        uiView.clear()

        let path = GMSMutablePath()
        for coordinate in coordinates {
            path.add(coordinate)
        }
        if let first = coordinates.first {
            path.add(first)
        }

        let polygon = GMSPolygon(path: path)
        polygon.fillColor = UIColor.blue.withAlphaComponent(0.4)
        polygon.strokeColor = .black
        polygon.strokeWidth = 3
        polygon.map = uiView
    }

    func updateMapGestures(_ mapView: GMSMapView, _ isDrawingEnabled: Bool) {
        mapView.settings.scrollGestures = !isDrawingEnabled
        mapView.settings.zoomGestures = !isDrawingEnabled
        mapView.settings.rotateGestures = !isDrawingEnabled
        mapView.settings.tiltGestures = !isDrawingEnabled
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: DrawingMapView
        var mapView: GMSMapView?
        var liveDrawingPath: GMSMutablePath?
        var liveDrawingPolyline: GMSPolyline?

        init(_ parent: DrawingMapView) {
            self.parent = parent
        }

       @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
            guard parent.isDrawingEnabled, let mapView = mapView else { return }

            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.projection.coordinate(for: touchPoint)

            switch gesture.state {
            case .began:
                liveDrawingPath = GMSMutablePath()
                liveDrawingPath?.add(coordinate)
                liveDrawingPolyline = GMSPolyline(path: liveDrawingPath)
                liveDrawingPolyline?.strokeColor = .blue
                liveDrawingPolyline?.strokeWidth = 3
                liveDrawingPolyline?.map = mapView

            case .changed:
                liveDrawingPath?.add(coordinate)
                liveDrawingPolyline?.path = liveDrawingPath

            case .ended:
                // **Fix: Store full path instead of only last point**
                var drawnCoordinates: [CLLocationCoordinate2D] = []
                for i in 0..<(liveDrawingPath?.count() ?? 0) {
                    drawnCoordinates.append(liveDrawingPath!.coordinate(at: i))
                }
                parent.coordinates = drawnCoordinates  // **Update all points**

                liveDrawingPolyline?.map = nil
                liveDrawingPolyline = nil
                liveDrawingPath = nil

            default:
                break
            }
        }

    }
}
