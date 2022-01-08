//
//  InterfaceController.swift
//  Jarvis WatchKit Extension
//
//  Created by Josh Spicer on 1/8/22.
//

import Foundation
import SwiftUI

class InterfaceController : WKHostingController<ContentView>, ObservableObject {
    
    override var body: ContentView {
        ContentView(model: JarvisModel())
    }
    
//    @IBAction func btnPlay() {
//        print("play!!")
//    }
    
//    func generateClientSecret() {
//        self.presentAlert(withTitle: "My Mesg", message: "hello", preferredStyle: .alert,
//                          actions: [
//                            WKAlertAction(title: "Close", style: .cancel, handler: { () -> Void in print("pressed")})
//                            ])
//    }
    
}
