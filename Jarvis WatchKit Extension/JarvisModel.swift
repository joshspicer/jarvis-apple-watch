//
//  InterfaceController.swift
//  Jarvis WatchKit Extension
//
//  Created by Josh Spicer on 12/26/21.
//

import Foundation
import SwiftUI
import WatchConnectivity
import WatchKit
import CryptoKit
import EFQRCode

class JarvisModel {
    
    let JARVIS_GENERATED_KEY = "JARVIS_GENERATED_KEY"
    
    func boop() {
        print("boop")
    }
    
    func generateNewSecret() -> String {
        
        let newUUID = UUID().uuidString
        print("new UUID -> \(newUUID)")
        UserDefaults.standard.setValue(newUUID, forKey: JARVIS_GENERATED_KEY)
        
        return newUUID
    }
    
    func getSecret() -> String {
        let deviceId = WatchKit.WKInterfaceDevice.current().identifierForVendor?.uuidString
        if (deviceId == nil) {
            print("Failed to fetch DeviceId")
            return ""
        }
        print("DeviceId: \(deviceId!)")
        
        var generatedSecret: String = UserDefaults.standard.string(forKey: JARVIS_GENERATED_KEY) ?? ""
        if generatedSecret == "" {
            print("No secret saved in persistent storage. Generating one...")
            generatedSecret = generateNewSecret()
        }
                
        if generatedSecret == "" {
            print("Failed to get secret!")
            return ""
        }
        
        print("generatedSecret: \(generatedSecret)")
        
        let secret = "\(deviceId!)_\(generatedSecret)"
        print("Secret: \(secret)")

        return secret
    }
    

    func calculateHMAC(nonce: String) -> String {
        
        let secret = getSecret()
    
        // Generate HMAC with timestamp
        let symKey = SymmetricKey(data: secret.data(using: .utf8)!)
        let messageData = nonce.data(using: .utf8)!
        
        let signature = HMAC<SHA256>.authenticationCode(for: messageData, using: symKey)
        return Data(signature).map { String(format: "%02hhx", $0) }.joined()
    }

    func openButton() {
        print("openButton()")
        
        // Send to willow.party
        let url = URL(string: "")!
        print(url)

        var request = URLRequest(url: url)
        let unixTime: NSInteger = NSInteger(NSDate().timeIntervalSince1970)

        // Add Auth Header
        let nonce = "\(unixTime)_\(UUID().uuidString)"

        let hmac = calculateHMAC(nonce: nonce)
        request.httpMethod = "POST"

        // Add Auth Header
        request.httpBody = Data(base64Encoded: (nonce.data(using: .utf8)?.base64EncodedString())!)
        request.addValue(hmac, forHTTPHeaderField: "Authorization")
        
        // Change content type of body
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func qrCodeSecret() -> CGImage {
        let secret = getSecret()
        return EFQRCode.generate(
            for: secret
        )!
    }
}
