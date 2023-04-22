import MapKit
import CoreLocation

//IdentifiableCoordinate 用于将坐标显示到地图上（需要遵循Identifiable协议）
struct IdentifiableCoordinate: Identifiable {
	var id = UUID()
	var coordinate: CLLocationCoordinate2D
}

//LocationManager用于定位相关的功能，作为CLLocationManager的delegate对象
class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject  {
	@Published var mapRegion = MKCoordinateRegion()
	@Published var coordinates: [IdentifiableCoordinate] = []
	private var locationManager = CLLocationManager()

	override init() {
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

		let newCoordinates = locations.map{ IdentifiableCoordinate(coordinate: $0.coordinate) }
		self.coordinates.append(contentsOf: newCoordinates)
	}
}
