//
//  ClusterResponseView.swift
//  JarvisControlPanel
//
//  Created by Josh Spicer on 3/23/23.
//

import SwiftUI

struct ClusterResponseView: View {
    var data: ClusterResponse?
    var status: String
    var body: some View {
        if data != nil {
            VStack {
                HStack {
                    Text("High Voltage Battery")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("xxxx")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.system(size: 12))
                }
                .padding([.trailing, .leading])
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Charging")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("xxxx")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding([.trailing, .leading])
                .frame(maxWidth: .infinity)
            }
        } else {
          Spacer()
            if status != "" {
                Text(status)
                    .font(.system(size: 14))
                    .padding(10)
                    .padding([.leading, .trailing], 50)
                    .background(.gray)
                    .cornerRadius(20)
                    .foregroundColor(Color.white)
            }
//          Text(verbatim: "¯\\_(ツ)_/¯")
        }
      }
}

//struct ClusterResponseView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClusterResponseView()
//    }
//}
