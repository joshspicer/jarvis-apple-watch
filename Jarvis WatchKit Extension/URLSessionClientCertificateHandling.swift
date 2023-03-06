//
//  URLSessionClientCertificateHandling.swift
//  Jarvis WatchKit Extension
//
//  Written by Marco Eidnger
//      -   https://github.com/MarcoEidinger/ClientCertificateSwiftDemo
//      -   https://blog.eidinger.info/client-certificate-handling-on-ios
//
//  Edited by Josh Spicer on 3/5/23.
//

import Foundation

public class URLSessionClientCertificateHandling: NSObject, URLSessionDelegate {
    public func urlSession(_: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.protectionSpace.authenticationMethod
            == NSURLAuthenticationMethodClientCertificate
        else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        guard let credential = JarvisApp.urlCredential(for: Bundle.main.userCertificate) else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        challenge.sender?.use(credential, for: challenge)
        completionHandler(.useCredential, credential)
    }
}
