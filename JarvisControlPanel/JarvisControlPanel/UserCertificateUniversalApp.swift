//
//  UserCertificateUniversalApp.swift
//  JarvisControlPanel
//
//  Created by Josh Spicer on 3/11/23.
//

import Foundation

extension JarvisControlPanelApp {
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
