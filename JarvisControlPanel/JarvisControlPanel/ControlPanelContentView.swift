//
//  ControlPanelContentView.swift
//  JarvisControlPanel
//
//  Created by Josh Spicer on 3/11/23.
//

import SwiftUI

struct ControlPanelContentView: View {
    var model: JarvisModel
    @State private var response = ""
    var body: some View {
        VStack {
            Button(action: {
                response = "..."
                model.query(q: QueryRequest.Node("health",
                                                    "GET",
                                                    QueryType.PlainText,
                                                    AuthMode.None,
                                                    CertMode.ClientCert), res: $response)
            }) {
                    HStack {
                        Text("Node Health")
                    }
                   
                }
                .padding()
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(40)
            
            Text(response)

        }
        .padding()
    }
}

struct ControlPanelContentView_Previews: PreviewProvider {
    static var previews: some View {
        ControlPanelContentView(model: JarvisModel())
    }
}
