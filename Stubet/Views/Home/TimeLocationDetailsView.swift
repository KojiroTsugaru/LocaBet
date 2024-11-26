import SwiftUI
import MapKit

struct TimeLocationDetailsView: View {
    
    let newBetData: NewBetData
    @State private var region: MKCoordinateRegion
    
    init(newBetData: NewBetData) {
        self.newBetData = newBetData
        // Initialize the region with selectedCoordinates
        self._region = State(initialValue: MKCoordinateRegion(
            center: newBetData.selectedCoordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        VStack() {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 20))
                Spacer()
                Text(formattedDate(date: newBetData.date, time: newBetData.time))
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.leading)
                Spacer()
                Text("1分後")
                    .font(.system(size: 16))
                    .foregroundColor(.orange)
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
                    Text("0.1 km")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)

            // Map Section
            Map(coordinateRegion: $region)
                .frame(height: 200)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 10)


            // Confirmation Button
            Button(action: {
                // Action for map confirmation
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
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}

func formattedDate(date: Date, time: Date) -> String {
    let dateFormatter = DateFormatter()
    
    // Set the date format
    dateFormatter.dateFormat = "MM/dd/yyyy"
    let dateString = dateFormatter.string(from: date)
    
    // Set the time format
    dateFormatter.dateFormat = "h:mm a"
    let timeString = dateFormatter.string(from: time)
    
    return "\(dateString) - \(timeString)"
}

struct TimeLocationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLocationDetailsView(newBetData: NewBetData(title: "テストベット", description: "アイス奢って！", locationName: "テストロケーション"))
    }
}
