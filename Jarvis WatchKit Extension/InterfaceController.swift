//
//  InterfaceController.swift
//  Jarvis WatchKit Extension
//
//  Created by Josh Spicer on 1/8/22.
//

import Foundation
import SwiftUI

class InterfaceController : WKHostingController<ContentView>, ObservableObject {
    override var body: ContentView {
        ContentView(model: JarvisModel())
    }
}
