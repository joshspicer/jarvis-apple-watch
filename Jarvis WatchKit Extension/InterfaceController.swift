//
//  InterfaceController.swift
//  Jarvis WatchKit Extension
//
//  Created by Josh Spicer on 12/26/21.
//

import Foundation
import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, ObservableObject {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

        
    func generateClientSecret() {
        self.presentAlert(withTitle: "My Mesg", message: "hello", preferredStyle: .alert,
                          actions: [
                            WKAlertAction(title: "Close", style: .cancel, handler: { () -> Void in print("pressed")})
                            ])
    }
        
    func openButton() {
           print("did it!!!!")
           print(UIDevice.current.identifierForVendor!.uuidString)
           
           // Fetch Cached Secret from storage
           
           // Generate HMAC with timestamp
        
        // Send to willow.party
        let url = URL(string: "http://example.com")!
        print(url.scheme)

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
}
