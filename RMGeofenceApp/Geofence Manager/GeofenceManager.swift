//import Foundation
//import CoreLocation
//
//class GeofenceManager: NSObject, CLLocationManagerDelegate, ObservableObject {
//    private var locationManager: CLLocationManager?
//    private var geofenceRegions: [CLRegion] = []
//
//    @Published var didEnterGeofence: Bool = false
//    @Published var currentRegionIdentifier: String?
//
//    override init() {
//        super.init()
//        setupLocationManager()
//    }
//
//    private func setupLocationManager() {
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.requestAlwaysAuthorization()
//        locationManager?.startUpdatingLocation()
//    }
//
//    func startMonitoring(region: CLRegion) {
//        guard CLLocationManager.isMonitoringAvailable(for: type(of: region)) else {
//            print("Geofencing is not supported on this device.")
//            return
//        }
//
//        region.notifyOnEntry = true
//        region.notifyOnExit = true
//        geofenceRegions.append(region)
//        locationManager?.startMonitoring(for: region)
//    }
//
//    // CLLocationManagerDelegate Methods
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        if geofenceRegions.contains(region) {
//            handleGeofenceEvent(for: region, didEnter: true)
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        if geofenceRegions.contains(region) {
//            handleGeofenceEvent(for: region, didEnter: false)
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedAlways, .authorizedWhenInUse:
//            locationManager?.startUpdatingLocation()
//        case .denied, .restricted:
//            print("Location authorization denied or restricted.")
//            // Handle denied or restricted status appropriately
//        case .notDetermined:
//            locationManager?.requestAlwaysAuthorization()
//        @unknown default:
//            print("Unknown authorization status.")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location Manager failed with error: \(error.localizedDescription)")
//    }
//
//    // Override this method in subclasses to handle geofence events
//    func handleGeofenceEvent(for region: CLRegion, didEnter: Bool) {
//        DispatchQueue.main.async {
//            self.didEnterGeofence = didEnter
//            self.currentRegionIdentifier = region.identifier
//        }
//    }
//}
