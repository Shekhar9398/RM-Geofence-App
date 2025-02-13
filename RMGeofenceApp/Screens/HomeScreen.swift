
import SwiftUI

struct HomeScreen: View {
    var body: some View {
        ///Mark:- HomeScreenView 
        NavigationView {
            VStack(spacing: 20) {
                
                Text("RM Geofence Manager")
                    .font(.title2)
                    .bold()
                    .padding()
                
                ///Mark:- Monitor Geofence Button
                NavigationLink(destination: EmptyView()) {
                    VStack {
                        Image(systemName: "dot.radiowaves.left.and.right") // More relevant icon
                            .font(.system(size: 35))
                        
                        Text("Monitor")
                    }
                }
                .buttonStyle(RoundedButtonStyle(backgroundColor: .mint))
                
                ///Mark:- Create Geofence Button
                NavigationLink(destination: CreateGeofenceScreen()) {
                    VStack {
                        VStack {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 35))
                            
                            Text("Create")
                            
                        }
                    }
                }
                .buttonStyle(RoundedButtonStyle(backgroundColor: .black))
            }
        }
    }
}

#Preview {
    HomeScreen()
}
