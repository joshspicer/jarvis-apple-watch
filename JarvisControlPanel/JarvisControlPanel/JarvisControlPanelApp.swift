//
//  JarvisControlPanelApp.swift
//  JarvisControlPanel
//
//  Created by Josh Spicer on 3/11/23.
//

import SwiftUI

@main
struct JarvisControlPanelApp: App {
    var body: some Scene {
        WindowGroup {
            ControlPanelContentView(model: JarvisModel())
        }
    }
}
