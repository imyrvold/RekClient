//
//  RegisterView.swift
//  RekClient
//
//  Created by Ivan C Myrvold on 02/05/2021.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var username: String
    @Binding var email: String
    @Binding var password: String
    @ObservedObject var loginHandler: LoginHandler
    @State var confirmPassword = ""
    
    var isRegisterDisabled: Bool {
        username.isEmpty || email.isEmpty || password.isEmpty || (password != confirmPassword)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Enter Username", text: $username)
                    .autocapitalization(.none)
                HStack {
                    Image(systemName: "envelope.fill")
                    TextField("Enter Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }
                HStack {
                    Image(systemName: "lock.fill")
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                }
                HStack {
                    Image(systemName: "lock.fill")
                    SecureField("Confirm password", text: $confirmPassword)
                        .textContentType(.newPassword)
                }
            }
            .navigationTitle("Register")
            .toolbar(content: {
                Button("Register") {
                    self.presentationMode.wrappedValue.dismiss()
                    loginHandler.registerUser(username: username, email: email, password: password)
                }
                .disabled(isRegisterDisabled)
            })
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        let loginHandler = LoginHandler()
        RegisterView(username: .constant(""), email: .constant(""), password: .constant(""), loginHandler: loginHandler)
    }
}


