//
//  ContentView.swift
//  Jarvis WatchKit Extension
//
//  Created by Josh Spicer on 12/24/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var showSecondView = false

    @State private var pageOneResponse = ""
    @State private var pageTwoResponse = ""

    var model: JarvisWatchOSModel
    var body: some View {
        TabView {
            // First
            VStack {
                Button(action: {
                    pageOneResponse = "..."
                    model.query(q: QueryRequest.Node("health",
                                                        "GET",
                                                        QueryType.PlainText,
                                                        AuthMode.None,
                                                        CertMode.ClientCert), res: $pageOneResponse)
                }) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .font(.title)
                            Text("Node Health")
                                .fontWeight(.semibold)
                                .font(.system(size: 500))
                                .padding()
                                .minimumScaleFactor(0.01)
                                .lineLimit(1)
                        }
                       
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(40)
                
                Text(pageOneResponse)

            }
            // Second
            VStack {
                Button(action: {
                    pageTwoResponse = "..."
                    model.query(q: QueryRequest.Cluster("trustedknock",
                                                        "POST",
                                                        QueryType.StatusCode,
                                                        AuthMode.HMAC,
                                                        CertMode.None), res: $pageTwoResponse)
                }) {
                        HStack {
                            Image(systemName: "lock")
                                .font(.title)
                            Text("Open")
                                .fontWeight(.semibold)
                                .font(.system(size: 500))
                                .padding()
                                .minimumScaleFactor(0.01)
                                .lineLimit(1)
                        }
                       
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(.green)
                    .cornerRadius(40)
                
                Text(pageTwoResponse)

            }
                // Third
                Button(action: {
                    self.showSecondView.toggle()
            }) {
                    Image(systemName: "key")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(90)
                .scaledToFit()

                // Fourth
                Button(action: {
                   _ = model.generateNewSecret()
            }) {
                    Image(systemName: "key")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
                .background(.red)
                .cornerRadius(90)
                .scaledToFit()

                // Fifth
               }
               .tabViewStyle(.page)
               .sheet(isPresented: $showSecondView) {
                   QRImageView(model: model)
               }
    }
}

struct QRImageView: View {
    var model: JarvisWatchOSModel
    var body: some View {
        Image(model.qrCodeSecret(), scale: 5, orientation: .up, label: Text("QR"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: JarvisWatchOSModel())
    }
}
