//
//  UserCertificate.swift
//  Jarvis WatchKit Extension
//
//  Written by Marco Eidnger
//      -   https://github.com/MarcoEidinger/ClientCertificateSwiftDemo
//      -   https://blog.eidinger.info/client-certificate-handling-on-ios
//
//  Edited by Josh Spicer on 3/5/23.
//

import Foundation

typealias UserCertificate = (data: Data, password: String)

extension Bundle {
    /// data and password for bundle resource "badssl.com-client.p12"
    var userCertificate: UserCertificate? {
        guard let filePath = Bundle.main.path(forResource: VARIABLE_INFO_FILE_PATH, ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let certName = plist.object(forKey: CERTIFICATE_NAME) as? String,
              let certPassword = plist.object(forKey: CERTIFICATE_PASSWORD) as? String

        else {
            fatalError("Missing client certificate password in '\(VARIABLE_INFO_FILE_PATH)'")
        }
        
        guard let path = Bundle.main.path(forResource: certName, ofType: "p12"),
              let p12Data = try? Data(contentsOf: URL(fileURLWithPath: path))
        else {
            fatalError("Missing client certificate.")
        }
        return (p12Data, certPassword)
    }
}

extension JarvisApp {
    static func urlCredential(for userCertificate: UserCertificate?) -> URLCredential? {
        guard let userCertificate = userCertificate else { return nil }

        let p12Contents = PKCS12(pkcs12Data: userCertificate.data, password: userCertificate.password)

        guard let identity = p12Contents.identity else {
            return nil
        }

        // In most cases you should pass nil to the certArray parameter. You only need to supply an array of intermediate certificates if the server needs those intermediate certificates to authenticate the client. Typically this isn’t necessary because the server already has a copy of the relevant intermediate certificates.
        // See https://developer.apple.com/documentation/foundation/urlcredential/1418121-init
        return URLCredential(identity: identity,
                             certificates: nil,
                             persistence: .none)
    }
}

class PKCS12 {
    let label: String?
    let keyID: NSData?
    let trust: SecTrust?
    let certChain: [SecTrust]?
    let identity: SecIdentity?

    /// Creates a PKCS12 instance from a piece of data.
    /// - Parameters:
    ///   - pkcs12Data: the actual data we want to parse.
    ///   - password: the password required to unlock the PKCS12 data.
    public init(pkcs12Data: Data, password: String) {
        let importPasswordOption: NSDictionary
            = [kSecImportExportPassphrase as NSString: password]
        var items: CFArray?
        let secError: OSStatus
            = SecPKCS12Import(pkcs12Data as NSData,
                              importPasswordOption, &items)
        guard secError == errSecSuccess else {
            if secError == errSecAuthFailed {
                NSLog("Incorrect password?")
            }
            fatalError("Error trying to import PKCS12 data")
        }
        guard let theItemsCFArray = items else { fatalError() }
        let theItemsNSArray: NSArray = theItemsCFArray as NSArray
        guard let dictArray
            = theItemsNSArray as? [[String: AnyObject]]
        else {
            fatalError()
        }

        label = dictArray.element(for: kSecImportItemLabel)
        keyID = dictArray.element(for: kSecImportItemKeyID)
        trust = dictArray.element(for: kSecImportItemTrust)
        certChain = dictArray.element(for: kSecImportItemCertChain)
        identity = dictArray.element(for: kSecImportItemIdentity)
    }
}

extension Array where Element == [String: AnyObject] {
    func element<T>(for key: CFString) -> T? {
        for dictElement in self {
            if let value = dictElement[key as String] as? T {
                return value
            }
        }
        return nil
    }
}

