import SwiftUI
import CoreLocation

struct FullScreenMapView: View {
    var centerCoordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var title: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            CircularMapView(centerCoordinate: centerCoordinate, radius: radius, title: title)
                .edgesIgnoringSafeArea(.all)

            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .padding()
            }
        }
    }
}
