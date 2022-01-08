//
//  InterfaceController.swift
//  Jarvis WatchKit Extension
//
//  Created by Josh Spicer on 12/26/21.
//

import Foundation
import SwiftUI
import SpriteKit
import ClockKit
import WatchConnectivity
import WatchKit
import CryptoKit
import EFQRCode

class JarvisModel {
    
    func boop() {
        print("boop")
    }
    
    func calculateHMAC(msg: String) -> String {
        
        let secret = getSecret()
    
        // Generate HMAC with timestamp
        let symKey = SymmetricKey(data: secret.data(using: .utf8)!)
        let signature = HMAC<SHA256>.authenticationCode(for: msg.data(using: .utf8)!, using: symKey)
        return signature.description
    }
    
    func getSecret() -> String {
        let deviceId = WatchKit.WKInterfaceDevice.current().identifierForVendor?.uuidString
        if (deviceId == nil) {
            print("Failed to fetch DeviceId")
            return ""
        }
        print(deviceId!)

       // Fetch Cached Secret from storage?

        return "\(deviceId!)-BLAH"
    }

    func openButton() {
        print("openButton()")
        
        let msg = "OPEN"


        // Send to willow.party
        let url = URL(string: "http://52.149.228.51:13400")!
        print(url)
        
        // Add Auth Header
        
        
        var request = URLRequest(url: url)
        
        // Add Auth Header
        let hmac = calculateHMAC(msg: msg)
        request.httpMethod = "POST"
        request.httpBody = Data(base64Encoded: (msg.data(using: .utf8)?.base64EncodedString())!)
        request.addValue(hmac, forHTTPHeaderField: "Authentication")

        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func qrCodeSecret() -> CGImage {
        let secret = getSecret()
        return EFQRCode.generate(
            for: secret,
            watermark: UIImage(named: "WWF")?.cgImage
        )!
    }
}
