import SwiftUI
import MapKit

struct ContentView: View {
	@ObservedObject var locationManager = LocationManager()

	var body: some View {
		VStack{
			Map(coordinateRegion: $locationManager.mapRegion,
				showsUserLocation: true,
				annotationItems: locationManager.coordinates
			) { item in
				MapAnnotation(
					coordinate: CLLocationCoordinate2D(latitude: item.latitude,
													   longitude: item.longitude
													  )
				) {
					Circle().foregroundColor(.red)
				}
			}.edgesIgnoringSafeArea(.all)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
