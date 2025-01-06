import SwiftUI
import MapKit

struct IdentifiableCoordinate: Identifiable {
    let id = UUID() // Unique identifier for each coordinate
    let coordinate: CLLocationCoordinate2D
}

struct TimeLocationConfirmPanel: View {
    
    let newBetData: NewBetData
    @State private var region: MKCoordinateRegion
    private var annotatedCoordinate: IdentifiableCoordinate
    
    init(newBetData: NewBetData) {
        self.newBetData = newBetData
        let initialCoordinate = newBetData.selectedCoordinates
        // Initialize the region with selectedCoordinates
        self._region = State(initialValue: MKCoordinateRegion(
            center: newBetData.selectedCoordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
        self.annotatedCoordinate = IdentifiableCoordinate(coordinate: initialCoordinate)
    }
    
    var body: some View {
        VStack() {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 20))
                Spacer()
                Text(formattedDate(date: newBetData.deadline))
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.leading)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)

            // Location Section
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.orange)
                    .font(.system(size: 20))
                Spacer()
                VStack(alignment: .center, spacing: 4) {
                    Text(newBetData.locationName)
                        .font(.system(size: 16, weight: .semibold))
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            Map(
                coordinateRegion: $region,
                annotationItems: [annotatedCoordinate]
            ) { item in
                MapMarker(coordinate: item.coordinate, tint: .red)
            }
            .frame(height: 200)
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 10)
            
            
            // Confirmation Button
            Button(action: {
                // Action to open map
                openMaps()
            }) {
                Text("マップで確認する")
                    .font(.system(size: 16, weight: .semibold))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
    
    private func openMaps() {
        let latitude = annotatedCoordinate.coordinate.latitude
        let longitude = annotatedCoordinate.coordinate.longitude
        
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            // Open Google Maps
            let googleMapsURL = URL(string: "comgooglemaps://?q=\(latitude),\(longitude)&zoom=14")!
            UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
        } else {
            // Fallback to Apple Maps
            let appleMapsURL = URL(string: "http://maps.apple.com/?q=\(latitude),\(longitude)&z=14")!
            UIApplication.shared.open(appleMapsURL, options: [:], completionHandler: nil)
        }
    }
}

fileprivate func formattedDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    
    // Set the date format
    dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
    let dateString = dateFormatter.string(from: date)
    
    return dateString
}

struct TimeLocationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLocationConfirmPanel(newBetData: NewBetData(title: "テストベット", description: "アイス奢って！", locationName: "テストロケーション"))
    }
}
