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
    var model: JarvisModel
    var body: some View {
        TabView {
            // First
            Button(action: {
                model.openButton()
                
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
                    .padding()
                    .foregroundColor(.white)
                    .background(.green)
                    .cornerRadius(40)
                }

                // Second
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
        
                // Third
                Button(action: {
                    model.generateNewSecret()
            }) {
                    Image(systemName: "key")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
                .background(.red)
                .cornerRadius(90)
                .scaledToFit()
            
                // Fourth
               }
               .tabViewStyle(.page)
               .sheet(isPresented: $showSecondView) {
                   QRImageView(model: model)
               }
    }
}

func doSomething() {
    print("something")
}

struct QRImageView: View {
    var model: JarvisModel
    var body: some View {
        Image(model.qrCodeSecret(), scale: 5, orientation: .up, label: Text("QR"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: JarvisModel())
    }
}
