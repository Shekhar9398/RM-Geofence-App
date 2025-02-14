import SwiftUI
import GoogleMaps
import CoreLocation

// MARK: - DrawGeofenceView
struct DrawGeofenceView: View {
    @State private var coordinates: [CLLocationCoordinate2D] = []
    @State private var isDrawing: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Draw a custom geofence area")
                .foregroundColor(.orange)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            if isDrawing {
                DrawingMapView(coordinates: $coordinates, isDrawing: isDrawing)
                    .frame(height: 400)
                    .cornerRadius(10)
                    .padding()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 400)
                    .cornerRadius(10)
                    .overlay(Text("Map is inactive").foregroundColor(.gray))
                    .padding()
            }
            
            Button(action: {
                isDrawing.toggle()
            }) {
                Text(isDrawing ? "Stop Drawing" : "Start Drawing")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(isDrawing ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .bold()
            }
            .padding(.horizontal, 20)
            
            if !coordinates.isEmpty {
                Button(action: {
                    coordinates.removeAll()
                    isDrawing = false
                }) {
                    Text("Clear Drawing")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .bold()
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .navigationTitle("Custom Geofence Drawing")
    }
}

struct DrawGeofenceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DrawGeofenceView()
        }
    }
}
