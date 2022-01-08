//
//  JarvisApp.swift
//  Jarvis WatchKit Extension
//
//  Created by Josh Spicer on 12/24/21.
//

import SwiftUI
import WatchKit

@main
struct JarvisApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(model: JarvisModel())
            }
        }
        WKNotificationScene(controller: NotificationController.self, category: "JarvisUtility")
    }
}
