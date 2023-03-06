# Jarvis

Apple Watch app to interface with Jarvis web service.

## Setup

This is a companion app/frontend for [Jarvis](https://github/com/joshspicer/jarvis) and its associated services.  You'll need that running for this app to be useful.

### VariableInfo.plist

Create a plist file called `VariableInfo.plist` in the `Jarvis WatchKit Extension`. THe `VariableInfoModel.swift` illustrates what is needed.

### Add a client certificate

This app supports auth against a service with a client cert.  For example, with [Cloudflare's WAF](https://developers.cloudflare.com/ssl/client-certificates/configure-your-mobile-app-or-iot-device/).

`openssl pkcs12 -export -out cert.p12 -in cert.pem -inkey cert.key`
