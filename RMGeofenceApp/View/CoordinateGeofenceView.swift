
import SwiftUI

struct CoordinateGeofenceView: View {
    var body: some View {
        Text("please Enter Lattitudes and Longitudes for the geofence here")
            .foregroundStyle(.gray)
            .bold()
            .multilineTextAlignment(.center)
    }
}

#Preview {
    CoordinateGeofenceView()
}
