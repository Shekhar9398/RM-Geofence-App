import SwiftUI
import CoreLocation
// MARK: - Example Parent View Using DrawingMapView
struct CustomPolygonDrawingView: View {
    @State private var drawnCoordinates: [CLLocationCoordinate2D] = []
    
    var body: some View {
        VStack {
            Text("Tap on the map to draw a polygon")
                .font(.headline)
                .padding()
            
            DrawingMapView(coordinates: $drawnCoordinates, isDrawing: true)
                .frame(height: 300)
                .cornerRadius(10)
                .padding()
            
            if !drawnCoordinates.isEmpty {
                List {
                    ForEach(Array(drawnCoordinates.enumerated()), id: \.offset) { index, coordinate in
                        Text("Point \(index + 1): \(coordinate.latitude), \(coordinate.longitude)")
                    }
                }
            }
            
            Button(action: { drawnCoordinates.removeAll() }) {
                Text("Clear Drawing")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top)
            
            Spacer()
        }
        .navigationTitle("Custom Polygon Drawing")
    }
}

// MARK: - Preview Provider
struct CustomPolygonDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CustomPolygonDrawingView()
        }
    }
}

