import SwiftUI
import MapKit

struct SetLocationView: View {
    @ObservedObject var newBetData: NewBetData
    @Binding var showNewBetModal: Bool // Accept showNewBet as a Binding
    
    @State private var camera: MapCameraPosition = .automatic
    @State private var markerCoord: CLLocationCoordinate2D?
    
    @State private var locationName = ""
    
    var body: some View {
        
        VStack(spacing: 16) {
            MapReader { proxy in
                Map(position: $camera, interactionModes: .all) {
                    if let markerCoord = markerCoord  {
                        Marker(coordinate: markerCoord) {
                            Image(systemName: "flag.fill")
                        }
                    }
                }
                .cornerRadius(16)
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        print(coordinate)
                        markerCoord = coordinate
                    }
                }
            }
            
            // Location Name Field
            VStack(alignment: .leading, spacing: 8) {
                Text("場所の名前")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 16)
                
                TextField("例: 千葉大学１号館", text: $locationName)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
            }
            .padding(.vertical, 16)
        }
        .navigationBarTitle("場所を設定", displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink {
            ConfirmNewBetView(newBetData: newBetData, showNewBetModal: $showNewBetModal)
        } label: {
            Text("次へ")
                .font(.headline)
                .foregroundColor(Color.orange)
        }.simultaneousGesture(TapGesture().onEnded {
            // Set the value here before navigation
            newBetData.locationName = locationName
            if let markerCoord = markerCoord {
                newBetData.selectedCoordinates = IdentifiableCoordinate(coordinate: markerCoord)
            }
        }))
    }
    
}

#Preview {
    let mockNewBet = NewBetData()
    SetLocationView(newBetData: mockNewBet, showNewBetModal: .constant(true))
}

