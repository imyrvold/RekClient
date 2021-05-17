//
//  RegisterView.swift
//  RekClient (macOS)
//
//  Created by Ivan C Myrvold on 16/05/2021.
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
        Form {
            TextField("Enter Username", text: $username)
            
            HStack {
                Image(systemName: "envelope.fill")
                
                TextField("Enter Email", text: $email)
            }
            HStack {
                Image(systemName: "lock.fill")
                
                SecureField("Password", text: $password)
                    .textContentType(.password)
            }
            HStack {
                Image(systemName: "lock.fill")
                
                SecureField("Confirm password", text: $confirmPassword)
                    .textContentType(.password)
            }
        }
        .frame(width: 400, height: 400)
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        let loginHandler = LoginHandler()
        RegisterView(username: .constant(""), email: .constant(""), password: .constant(""), loginHandler: loginHandler)
    }
}
