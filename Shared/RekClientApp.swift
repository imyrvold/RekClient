//
//  RekClientApp.swift
//  Shared
//
//  Created by Ivan C Myrvold on 02/05/2021.
//

import SwiftUI

@main
struct RekClientApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var loginHandler = LoginHandler()

    var body: some Scene {
        WindowGroup {
            if loginHandler.authenticated {
                PhotoView(loginHandler: loginHandler)
                    .onChange(of: scenePhase, perform: { phase in
                        if phase == .active {
                            loginHandler.checkToken()
                        }
                    })
            } else {
                LoginView(loginHandler: loginHandler)
                    .onChange(of: scenePhase, perform: { phase in
                        if phase == .active {
                            loginHandler.checkToken()
                        }
                    })
                    .onAppear() {
                        loginHandler.checkToken()
                    }
            }
        }
    }
}
