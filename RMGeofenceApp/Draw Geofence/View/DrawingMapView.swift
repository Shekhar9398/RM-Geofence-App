import SwiftUI
import GoogleMaps
import CoreLocation

// MARK: - DrawingMapView (Interactive Polygon Drawing using Pan Gesture)
struct DrawingMapView: UIViewRepresentable {
    @Binding var coordinates: [CLLocationCoordinate2D]
    var isDrawing: Bool  // When true, panning on the map will add coordinates
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> GMSMapView {
        // Use a default center if no coordinates exist yet
        let initialCoordinate = coordinates.first ?? CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let camera = GMSCameraPosition.camera(withLatitude: initialCoordinate.latitude,
                                              longitude: initialCoordinate.longitude,
                                              zoom: 12)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        
        // Add a pan gesture recognizer for drawing
        let panGesture = UIPanGestureRecognizer(target: context.coordinator,
                                                action: #selector(Coordinator.handlePanGesture(_:)))
        panGesture.delegate = context.coordinator
        mapView.addGestureRecognizer(panGesture)
        
        // Optionally disable default scroll/zoom gestures if drawing is enabled
        mapView.settings.scrollGestures = !isDrawing
        mapView.settings.zoomGestures = !isDrawing
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        // Update gesture settings in case isDrawing changes
        mapView.settings.scrollGestures = !isDrawing
        mapView.settings.zoomGestures = !isDrawing
        
        // Clear previous overlays and markers
        mapView.clear()
        
        // Add a marker for each coordinate as visual feedback
        for coordinate in coordinates {
            let marker = GMSMarker(position: coordinate)
            marker.icon = GMSMarker.markerImage(with: .black)
            marker.map = mapView
        }
        
        // Only draw polygon if there are at least 3 coordinates
        guard coordinates.count >= 3 else { return }
        
        let path = GMSMutablePath()
        for coordinate in coordinates {
            path.add(coordinate)
        }
        // Close the polygon by adding the first coordinate again.
        if let first = coordinates.first {
            path.add(first)
        }
        
        let polygon = GMSPolygon(path: path)
        polygon.fillColor = UIColor.getRandomColor().withAlphaComponent(0.4)
        polygon.strokeColor = .black
        polygon.strokeWidth = 3
        polygon.map = mapView
        
        // Optionally, you could calculate and show a center marker here if desired.
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, GMSMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: DrawingMapView
        
        init(_ parent: DrawingMapView) {
            self.parent = parent
        }
        
        // Handle pan gesture to capture drawing touches
        @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
            guard let mapView = gesture.view as? GMSMapView else { return }
            // Only add coordinates when drawing is enabled
            guard parent.isDrawing else { return }
            
            let point = gesture.location(in: mapView)
            let coordinate = mapView.projection.coordinate(for: point)
            
            // Append coordinate continuously while panning (for .began or .changed)
            if gesture.state == .began || gesture.state == .changed {
                parent.coordinates.append(coordinate)
            }
        }
        
        // Allow pan gesture to work simultaneously with other gestures (if needed)
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        // Optionally, you could still implement didTapAt if you want both tap and pan support.
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            if parent.isDrawing {
                parent.coordinates.append(coordinate)
            }
        }
    }
}
