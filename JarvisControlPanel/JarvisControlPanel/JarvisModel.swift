//
//  InterfaceController.swift
//  Jarvis WatchKit Extension
//
//  Created by Josh Spicer on 12/26/21.
//
//
//

import Foundation
import SwiftUI
import WatchConnectivity
import CryptoKit


enum QueryType {
    case StatusCode
    case PlainText
    case JSON
}

enum AuthMode {
    case None
    case HMAC
}

enum CertMode {
    case None
    case ClientCert
}

enum QueryRequest {
    // Service(Route, Method, QueryType, UseHMACAuth, UseClientCert)
    case Cluster(String, String, QueryType, AuthMode, CertMode)
    case Node(String, String, QueryType, AuthMode, CertMode)
}

class JarvisModel {
    
    let JARVIS_GENERATED_KEY = "JARVIS_GENERATED_KEY"
        
    // Cache important variables from VariableInfo
    var clusterServiceUri: String
    var nodeServiceUri: String
    
    
    init() {
        guard let filePath = Bundle.main.path(forResource: VARIABLE_INFO_FILE_PATH, ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: filePath)
        else {
            fatalError("Couldn't find file '\(VARIABLE_INFO_FILE_PATH).plist'.")
        }
        self.clusterServiceUri = plist.object(forKey: CLUSTER_SERVICE_URI_KEY) as? String ?? ""
        self.nodeServiceUri = plist.object(forKey: NODE_SERVICE_URI_KEY) as? String ?? ""
        
        ValidateInit()
    }
    
    private func ValidateInit() {
        if self.clusterServiceUri == "" {
            fatalError("\(CLUSTER_SERVICE_URI_KEY) not set.")
        }
        if self.nodeServiceUri == "" {
            fatalError("\(NODE_SERVICE_URI_KEY) not set.")
        }
    }



    internal func generateNewSecret() -> String {
        let newUUID = UUID().uuidString
        let secret = "v2_\(newUUID)"
        UserDefaults.standard.setValue(secret, forKey: JARVIS_GENERATED_KEY)
        return secret
    }
    
    internal func getSecret() -> String {
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
    

    private func calculateHMAC(nonce: String) -> String {
        
        let secret = getSecret()
        
        print("nonce -> \(nonce)")
    
        // Generate HMAC with timestamp
        let symKey = SymmetricKey(data: secret.data(using: .utf8)!)
        let messageData = nonce.data(using: .utf8)!
        
        let signature = HMAC<SHA256>.authenticationCode(for: messageData, using: symKey)
        return Data(signature).map { String(format: "%02hhx", $0) }.joined()
    }

    func query(q: QueryRequest, res: Binding<String>) {
        print("openButton()")
        
        let service: String
        let route: String
        let method: String
        let queryType: QueryType
        let authMode: AuthMode
        let certMode: CertMode
        
        switch q {
        case let .Cluster(r, m, q, a, c):
            print("Cluster: \(r) \(m) \(q) \(a) \(c)")
            service = clusterServiceUri
            method = m
            route = r
            queryType = q
            authMode = a
            certMode = c
        case let .Node(r, m, q, a, c):
            print("Node: \(r) \(m) \(q) \(a) \(c)")
            service = nodeServiceUri
            route = r
            method = m
            queryType = q
            authMode = a
            certMode = c
        }

        // Target URI
        let url = URL(string: "\(service)/\(route)")!
        print(url)

        var request = URLRequest(url: url)
        request.httpMethod = method

        if authMode == AuthMode.HMAC {
            let unixTime: NSInteger = NSInteger(NSDate().timeIntervalSince1970)

            // Add Auth Header
            let nonce = "\(unixTime)_\(UUID().uuidString)"

            let hmac = calculateHMAC(nonce: nonce)
            print("hmac -> \(hmac)")

            // Add Headers
            request.addValue(hmac, forHTTPHeaderField: "Authorization")
            request.addValue(nonce, forHTTPHeaderField: "X-Jarvis-Timestamp")
        }
        
//        let currentDevice = WatchKit.WKInterfaceDevice.current()
//        let device = currentDevice.name
//        request.addValue(device, forHTTPHeaderField: "X-Jarvis-Device")

        // Change content type of body
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default, delegate: certMode == CertMode.ClientCert ? URLSessionClientCertificateHandling() : nil, delegateQueue: nil)
        
        let task = session.dataTask(with: request) {(data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if queryType == QueryType.StatusCode {
                    res.wrappedValue = String(httpResponse.statusCode)
                    return
                }
                
                if httpResponse.statusCode > 299 {
                    res.wrappedValue = "ERR (\(httpResponse.statusCode))"
                    return
                }
                
                let stringResponse = String(data: data!, encoding: String.Encoding.utf8)
                res.wrappedValue = stringResponse ?? "ERR"
                
            } else {
                res.wrappedValue = "ERR"
            }
        }

        task.resume()
    }
    
    private func sendHTTPRequest(request: URLRequest, useCertificate: Bool) async -> String {
        let session = URLSession(configuration: .default, delegate: useCertificate ? URLSessionClientCertificateHandling() : nil, delegateQueue: nil)
        do {
            let (data, response) = try await session.data(for: request, delegate: nil)
            
            guard let httpResponse = response as? HTTPURLResponse else { return "" }
            print("(!) \(httpResponse.statusCode)")
            
            let stringResponse = String(data: data, encoding: String.Encoding.utf8)
            return stringResponse ?? ""

        } catch {
            return error.localizedDescription
        }
    }
}
