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
        let deviceId = WatchKit.WKInterfaceDevice.current().identifierForVendor?.uuidString
        if (deviceId == nil) {
            print("Failed to fetch DeviceId")
            return ""
        }
        print("DeviceId -> \(deviceId!)")
        
        let newUUID = UUID().uuidString
        print("new UUID -> \(newUUID)")
        
        let secret = "\(deviceId!)_\(newUUID)"
        UserDefaults.standard.setValue(secret, forKey: JARVIS_GENERATED_KEY)
        return secret
    }
    
    func getSecret() -> String {
        var cachedSecret: String = UserDefaults.standard.string(forKey: JARVIS_GENERATED_KEY) ?? ""
        if cachedSecret == "" {
            print("No secret cached in persistent storage. Generating one...")
            cachedSecret = generateNewSecret()
        }
                
        if cachedSecret == "" {
            print("Failed to get secret!")
            return ""
        }
        
        print("Secret ->  \(cachedSecret)")
        return cachedSecret
    }
    

    func calculateHMAC(nonce: String) -> String {
        
        let secret = getSecret()
        
        print("nonce -> \(nonce)")
    
        // Generate HMAC with timestamp
        let symKey = SymmetricKey(data: secret.data(using: .utf8)!)
        let messageData = nonce.data(using: .utf8)!
        
        let signature = HMAC<SHA256>.authenticationCode(for: messageData, using: symKey)
        return Data(signature).map { String(format: "%02hhx", $0) }.joined()
    }

    func openButton(responseString: Binding<String>) {
        print("openButton()")
        
        // Send to willow.party
        let url = URL(string: "http://willow.party/trustedknock")!
        print(url)

        var request = URLRequest(url: url)
        let unixTime: NSInteger = NSInteger(NSDate().timeIntervalSince1970)

        // Add Auth Header
        let nonce = "\(unixTime)_\(UUID().uuidString)"

        let hmac = calculateHMAC(nonce: nonce)
        print("hmac -> \(hmac)")
        request.httpMethod = "POST"

        // Add Auth Header
        request.httpBody = Data(base64Encoded: (nonce.data(using: .utf8)?.base64EncodedString())!)
        request.addValue(hmac, forHTTPHeaderField: "Authorization")
        
        // Change content type of body
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                responseString.wrappedValue = String(httpResponse.statusCode)
            } else {
                responseString.wrappedValue = "ERR"
            }
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
