//
//  ContentView.swift
//  Jarvis WatchKit Extension
//
//  Created by Josh Spicer on 12/24/21.
//

import SwiftUI
import Combine

struct ContentView: View {
//    @ObservedObject var icLink = ICLink()
    var body: some View {
        TabView {
            // First
            Button(action: {
                doSomething()
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
                print("Key Button")
            }) {
                    Image(systemName: "key")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(90)
                .scaledToFit()
        
                // Third
            
                // Fourth
               }
               .tabViewStyle(.page)
    }
}

func doSomething() {
    print("something")
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
