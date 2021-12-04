/*
See LICENSE.txt for this sample’s licensing information.
*/

import ARHeadsetKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        let description = Coordinator.AppDescription(name: "My App")
        
        ARContentView<SettingsView>()
            .environmentObject(Coordinator(appDescription: description))
    }
}

class MyApp_MainRenderer: MainRenderer {
    override var makeCustomRenderer: CustomRendererInitializer {
        GameRenderer.init
    }
    
    override class var interfaceDepth: Float {
        0.7
    }
}

class Coordinator: AppCoordinator {
    @Published var renderARLabelsHorizontally: Bool = false
    
    override var makeMainRenderer: MainRendererInitializer {
        MyApp_MainRenderer.init
    }
    
    override func initializeCustomSettings(from storedSettings: [String: String]) {
        if let renderARLabelsHorizontally_String = storedSettings["renderARLabelsHorizontally"],
           let renderARLabelsHorizontally_Bool = Bool(renderARLabelsHorizontally_String) {
            renderARLabelsHorizontally = renderARLabelsHorizontally_Bool
        }
    }
    
    override func modifyCustomSettings(customSettings: inout [String: String]) {
        let renderARLabelsHorizontally_String = String(renderARLabelsHorizontally)
        
        if renderARLabelsHorizontally_String != customSettings["renderARLabelsHorizontally"] {
            customSettings["renderARLabelsHorizontally"] = renderARLabelsHorizontally_String
        }
    }
}

struct SettingsView: CustomRenderingSettingsView {
    @ObservedObject var coordinator: Coordinator
    init(c: Coordinator) { coordinator = c }
    
    var body: some View {
        Toggle("Orient Velocity Label for Landscape Mode", isOn: $coordinator.renderARLabelsHorizontally)
    }
}
