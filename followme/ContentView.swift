import SwiftUI
import MapKit

struct ContentView: View {
	@ObservedObject var locationManager = LocationManager()

	var body: some View {
		Map(coordinateRegion: $locationManager.mapRegion, showsUserLocation: true)
			.edgesIgnoringSafeArea(.all)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
