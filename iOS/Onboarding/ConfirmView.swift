//
//  ConfirmView.swift
//  RekClient (iOS)
//
//  Created by Ivan C Myrvold on 17/05/2021.
//

import SwiftUI

struct ConfirmView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var verificationCode = ""
    var username: String
    @ObservedObject var loginHandler: LoginHandler
    
    var isConfirmationButtonDisabled: Bool {
        verificationCode.count != 6
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Verification Code", text: $verificationCode)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Confirm Verification Code")
            .toolbar(content: {
                Button("Confirm") {
                    self.presentationMode.wrappedValue.dismiss()
                    loginHandler.confirmSignup(with: username, and: verificationCode)
                }
                .disabled(isConfirmationButtonDisabled)
            })
        }
    }
}

struct ConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        let loginHandler = LoginHandler()
        ConfirmView(username: "myuser", loginHandler: loginHandler)
    }
}
