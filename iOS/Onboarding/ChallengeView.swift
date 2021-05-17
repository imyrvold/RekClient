//
//  ChallengeView.swift
//  RekClient (iOS)
//
//  Created by Ivan C Myrvold on 17/05/2021.
//

import SwiftUI

struct ChallengeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var newPassword = ""
    @ObservedObject var loginHandler: LoginHandler
    
    var isButtonDisabled: Bool {
        newPassword.count < 6
    }

    var body: some View {
        NavigationView {
            Form {
                SecureField("New Password", text: $newPassword)
                    .textContentType(.newPassword)
            }
            .navigationTitle("Change Password")
            .toolbar(content: {
                Button("Change") {
                    self.presentationMode.wrappedValue.dismiss()
                    loginHandler.handleChallenge(with: newPassword)
                }
                .disabled(isButtonDisabled)
            })
        }
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        let loginHandler = LoginHandler()
        ChallengeView(loginHandler: loginHandler)
    }
}
