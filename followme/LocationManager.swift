import MapKit
import CoreLocation
import CoreData

//LocationManager用于定位相关的功能，作为CLLocationManager的delegate对象
class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject  {
	@Published var mapRegion = MKCoordinateRegion()
	@Published var coordinates: [Coordinate] = []
	private var locationManager = CLLocationManager()
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Followme")
		container.loadPersistentStores { description, error in
			if let error = error {
				fatalError("Unable to load persistent stores: \(error)")
			}
		}
		return container
	}()

	override init() {
		super.init()
		let fetchRequest = Coordinate.fetchRequest()
		let historyCoordinates = try? persistentContainer.viewContext.fetch(fetchRequest)
		if let historyCoordinates {
			self.coordinates.append(contentsOf: historyCoordinates)
		}
		locationManager.delegate = self
		locationManager.pausesLocationUpdatesAutomatically = false
		locationManager.allowsBackgroundLocationUpdates = true
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

		let coordinateEntity = Coordinate.entity()
		for location in locations {
			let coordinate = Coordinate(entity: coordinateEntity, insertInto: persistentContainer.viewContext)
			coordinate.time = location.timestamp
			coordinate.latitude = location.coordinate.latitude
			coordinate.longitude = location.coordinate.longitude
			self.coordinates.append(coordinate)
		}
		try? persistentContainer.viewContext.save()
	}
}
