import MapKit
import CoreLocation

//LocationManager用于定位相关的功能，作为CLLocationManager的delegate对象
class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject  {
	@Published var mapRegion: MKCoordinateRegion
	private var locationManager = CLLocationManager()

	override init() {
		self.mapRegion = MKCoordinateRegion()
		super.init()
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()
		locationManager.startUpdatingLocation()
	}

	//位置更新时，重新计算地图区域
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let lastLocation = locations.last else {
			return
		}

		self.mapRegion = MKCoordinateRegion(
			center: lastLocation.coordinate,
			latitudinalMeters: 1000,
			longitudinalMeters: 1000
		)
	}
}
