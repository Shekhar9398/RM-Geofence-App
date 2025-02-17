import SwiftUI
import GoogleMaps

// MARK: - Custom Polygon Drawing View
struct CustomPolygonDrawingView: View {
    @State private var drawnCoordinates: [CLLocationCoordinate2D] = []
    @State private var isDrawingEnabled: Bool = true
    @Binding var polygonColor : UIColor
    
    var body: some View {
        ZStack {
            DrawingMapView(
                coordinates: $drawnCoordinates,
                isDrawingEnabled: $isDrawingEnabled
            )
            .edgesIgnoringSafeArea(.all)  // Full-screen map view
            
            VStack {
                Spacer()
                
                if isDrawingEnabled {
                    Button(action: {
                        if drawnCoordinates.count >= 3 {
                            // Finish drawing the polygon
                            isDrawingEnabled = false
                        }
                    }) {
                        Text("Done")
                            .bold()
                            .frame(width: 100, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 50)
                }

                if !drawnCoordinates.isEmpty {
                    List {
                        ForEach(Array(drawnCoordinates.enumerated()), id: \.offset) { index, coordinate in
                            Text("Point \(index + 1): \(coordinate.latitude), \(coordinate.longitude)")
                        }
                    }
                    .frame(height: 150) // Show list of coordinates of the drawn polygon
                }

                Button(action: {
                    drawnCoordinates.removeAll()  // Clear the drawing
                    isDrawingEnabled = true  // Enable drawing mode
                }) {
                    Text("Clear Drawing")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top)
            }
        }
        .navigationTitle("Custom Polygon Drawing")
    }
}

