//
//  InterfaceController.swift
//  Jarvis WatchKit Extension
//
//  Created by Josh Spicer on 12/26/21.
//

import CryptoKit
import Foundation
import SwiftUI

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
  case Cluster(String, String, QueryType, AuthMode, CertMode)
  case Node(String, String, QueryType, AuthMode, CertMode)
}

struct NodeResponse: Decodable, Equatable {
  let accessoriesBattery: Int
  let gpsLatitude: Double
  let gpsLongitude: Double
  let signalStrength: Int
}

struct ClusterResponse: Decodable, Equatable {
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

  public func setSecret(newSecret: String) {
    if newSecret == "" {
      return
    }
    UserDefaults.standard.setValue(newSecret, forKey: JARVIS_GENERATED_KEY)
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

  func query<T: Decodable>(q: QueryRequest, status: Binding<String>, responseData: Binding<T>) {
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

    let session = URLSession(
      configuration: .default,
      delegate: certMode == CertMode.ClientCert ? URLSessionClientCertificateHandling() : nil,
      delegateQueue: nil)

    let task = session.dataTask(with: request) { (data, response, error) in
      if let httpResponse = response as? HTTPURLResponse {
        print(httpResponse.statusCode)

        if queryType == QueryType.StatusCode {
          status.wrappedValue = String(httpResponse.statusCode)
          // No Data
          return
        }

        if httpResponse.statusCode > 299 {
          status.wrappedValue = "ERR (\(httpResponse.statusCode))"
          // No Data
          return
        }

        //let stringResponse = String(data: data!, encoding: String.Encoding.utf8)
        status.wrappedValue = String(httpResponse.statusCode)

        if queryType == QueryType.PlainText {
          let stringResponse = String(data: data!, encoding: String.Encoding.utf8)
          do {
            responseData.wrappedValue = stringResponse as! T
          } catch {
            print("Error decoding PlainText to type T: \(error)")
            status.wrappedValue = "Decode ERR: \(error)"
          }
          return
        }

        // Parse JSON and cast to T
        if queryType == QueryType.JSON {
          let decoder = JSONDecoder()
          do {
            let decoded = try decoder.decode(T.self, from: data!)
            responseData.wrappedValue = decoded
          } catch {
            print("Error decoding JSON: \(error)")
            status.wrappedValue = "Decode ERR: \(error)"
          }
        } else {
          status.wrappedValue = "ERR"
        }
      }
    }

    task.resume()
  }

  private func sendHTTPRequest(request: URLRequest, useCertificate: Bool) async -> String {
    let session = URLSession(
      configuration: .default,
      delegate: useCertificate ? URLSessionClientCertificateHandling() : nil, delegateQueue: nil)
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
