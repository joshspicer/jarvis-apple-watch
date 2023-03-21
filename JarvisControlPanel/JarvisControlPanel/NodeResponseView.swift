//
//  NodeResponseView.swift
//  JarvisControlPanel
//
//  Created by Josh Spicer on 3/19/23.
//

import SwiftUI

struct NodeResponseView: View {
    var data: NodeResponse?
    var body: some View {
//        Text("\(String(data.gpsLocation.latitude)), \(String(data.gpsLocation.longitude))")
        if data != nil {
            VStack {
                // header
                HStack {
                    Text("JADE") // 'Node' Header.
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 20))
                }
                .padding()

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
            }
            .frame(maxWidth: .infinity)
        } else {
            Text(verbatim: "¯\\_(ツ)_/¯")
        }
    }
}

//struct NodeResponseView_Previews: PreviewProvider {
//    var response: NodeReponse
//    static var previews: some View {
//        NodeResponseView(response: response)
//    }
//}
