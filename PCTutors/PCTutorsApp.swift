//
//  PCTutorsApp.swift
//  PCTutors
//
//  Created by Jack Frank on 8/18/22.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct PCTutorsApp: App {
    @StateObject private var modelData = ModelData()
    @ObservedObject var sessionManager = SessionManager()
    init() {
        configureAmplify()
        sessionManager.getCurrentAuthUser()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}


private func configureAmplify() {
    do {
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.configure()
        print("Amplify configured successfully")
        
    } catch {
        print("could not initialize Amplify", error)
    }
}
