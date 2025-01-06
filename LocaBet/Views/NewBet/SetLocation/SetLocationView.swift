import SwiftUI
import MapKit

struct SetLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var newBetData: NewBetData
    @Binding var showNewBetModal: Bool // Accept showNewBet as a Binding
    
    @State private var camera: MapCameraPosition = .automatic
    @State private var markerCoord: CLLocationCoordinate2D?
    @State private var locationName = ""
    @State private var isLocationSelected = false
    
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
                        isLocationSelected = true
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
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack(spacing: 2) {
                    Image(systemName: "chevron.left")
                    Text("戻る")
                }.foregroundColor(Color.orange)
            }),
            trailing: NavigationLink {
                ConfirmNewBetView(
                    newBetData: newBetData,
                    showNewBetModal: $showNewBetModal
                )
            } label: {
                Text("次へ")
                    .foregroundColor(Color.orange)
            }.simultaneousGesture(TapGesture().onEnded {
                // Set the value here before navigation
                newBetData.locationName = locationName
                if let markerCoord = markerCoord {
                    newBetData.selectedCoordinates = markerCoord
                }
            })
            .disabled(!isLocationSelected)
        )
        .onAppear {
            // initialize camera position
            if let currentLocation = LocationManager.shared.currentLocation {
                camera = 
                    .camera(
                        MapCamera(
                            centerCoordinate: currentLocation.coordinate,
                            distance: 1000
                        )
                    )
            }
        }
    }
    
}

//#Preview {
//    let mockNewBet = NewBetData(title: "", description: "", locationName: "")
//    SetLocationView(newBetData: mockNewBet, showNewBetModal: .constant(true))
//}

