//
//  JarvisWatchOSModel.swift
//  Jarvis WatchKit Extension
//
//  Created by Josh Spicer on 3/11/23.
//

import Foundation
import WatchKit
import EFQRCode

class JarvisWatchOSModel: JarvisModel {
    
    func qrCodeSecret() -> CGImage {
        let secret = getSecret()
        return EFQRCode.generate(
            for: secret
        )!
    }
}
