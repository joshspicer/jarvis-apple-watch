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
            Text(String(data?.signalStrength ?? -99))
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
