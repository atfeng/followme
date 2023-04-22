import SwiftUI
import MapKit

struct ContentView: View {
	@State private var mapRegion = MKCoordinateRegion(
		center: CLLocationCoordinate2D(latitude: 30.568744,
									   longitude: 104.063402),
		latitudinalMeters: 1000,
		longitudinalMeters: 1000
	)
	var body: some View {
		Map(coordinateRegion: $mapRegion)
			.edgesIgnoringSafeArea(.all)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
