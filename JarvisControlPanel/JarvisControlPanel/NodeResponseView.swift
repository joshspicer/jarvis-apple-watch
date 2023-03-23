//
//  NodeResponseView.swift
//  JarvisControlPanel
//
//  Created by Josh Spicer on 3/19/23.
//

import MapKit
import SwiftUI

struct IdentifiablePlace: Identifiable {
  let id: UUID
  let location: CLLocationCoordinate2D
  init(id: UUID = UUID(), lat: Double, long: Double) {
    self.id = id
    self.location = CLLocationCoordinate2D(
      latitude: lat,
      longitude: long)
  }
}

struct CurrentLocationMap: View {

  @State private var region: MKCoordinateRegion
  @State private var latitude: Double
  @State private var longitude: Double
  init(lat: Double, lng: Double) {
    latitude = lat
    longitude = lng
    region = MKCoordinateRegion(
      center: CLLocationCoordinate2D(
        latitude: lat,
        longitude: lng),
      latitudinalMeters: 750,
      longitudinalMeters: 750
    )
  }

  var body: some View {
    Map(
      coordinateRegion: $region,
      annotationItems: [IdentifiablePlace(lat: latitude, long: longitude)]
    ) { place in
      MapMarker(
        coordinate: place.location,
        tint: Color.green)
    }
  }
}

struct NodeResponseView: View {
  var data: NodeResponse?
    var status: String
  var body: some View {
    if data != nil {
      VStack {
        // header
        //        HStack {
        //          Text("JADE")  // 'Node' Header.
        //            .bold()
        //            .frame(maxWidth: .infinity, alignment: .center)
        //            .font(.system(size: 20))
        //        }
        //        .padding()

        // Map
        CurrentLocationMap(lat: data!.gpsLatitude, lng: data!.gpsLongitude)
          .cornerRadius(10)
          .frame(height: 200)
          .padding()

        HStack {
          Text("GPS Location")
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
          Text("\(data!.gpsLatitude), \(data!.gpsLongitude)")
            .frame(maxWidth: .infinity, alignment: .trailing)
            .font(.system(size: 12))
        }
        .padding([.trailing, .leading])
        .frame(maxWidth: .infinity)

        HStack {
          Text("Accessories Battery")
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
          Text("\(String(data!.accessoriesBattery))%")
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding([.trailing, .leading])
        .frame(maxWidth: .infinity)

        HStack {
          Text("Signal Strength")
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
          Text(String(data!.signalStrength))
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding([.trailing, .leading])
        .frame(maxWidth: .infinity)
      }
      .frame(maxWidth: .infinity)
    } else {
      Spacer()
        
        if status == "" {
            Text(verbatim: "¯\\_(ツ)_/¯")
        } else {
            Text(status)
                .font(.system(size: 14))
                .padding(10)
                .padding([.leading, .trailing], 50)
                .background(.gray)
                .cornerRadius(20)
                .foregroundColor(Color.white)
        }  
    }
  }
}

//struct NodeResponseView_Previews: PreviewProvider {
//    var response: NodeReponse
//    static var previews: some View {
//        NodeResponseView(response: response)
//    }
//}
