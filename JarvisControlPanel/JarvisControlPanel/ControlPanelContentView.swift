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
    @State private var secret: String = ""
    var body: some View {
        VStack {
            HStack {
                Text("HMAC Secret")
                TextField(
                    "Secret",
                    text: $secret
                )
            }
            HStack {
                Button(action: {
                    response = "..."
                    model.setSecret(newSecret: $secret.wrappedValue)
                    model.query(q: QueryRequest.Node("health",
                                                     "GET",
                                                     QueryType.PlainText,
                                                     AuthMode.None,
                                                     CertMode.ClientCert), res: $response)
                }) {
                    HStack {
                        Text("Node /health")
                    }
                    
                }
                .padding()
                .foregroundColor(.blue)
                .background(.blue)
                .cornerRadius(40)
            }
            HStack {
                Button(action: {
                    response = "..."
                    model.setSecret(newSecret: $secret.wrappedValue)
                    model.query(q: QueryRequest.Node("info",
                                                     "GET",
                                                     QueryType.PlainText,
                                                     AuthMode.HMAC,
                                                     CertMode.ClientCert), res: $response)
                }) {
                    HStack {
                        Text("Node /info")
                    }
                    
                }
                .padding()
                .foregroundColor(.blue)
                .background(.blue)
                .cornerRadius(40)
            }
        }
        .padding()
        Text(response)
    }
}

struct ControlPanelContentView_Previews: PreviewProvider {
    static var previews: some View {
        ControlPanelContentView(model: JarvisModel())
    }
}
