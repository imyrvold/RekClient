//
//  LoginView.swift
//  RekClient (macOS)
//
//  Created by Ivan C Myrvold on 16/05/2021.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var verificationCode = ""
    @State private var showForm = false
    @State var newPassword = ""
    @ObservedObject var loginHandler: LoginHandler

    var buttonDisabled: Bool {
        showForm == true || username.isEmpty || password.isEmpty
    }

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .background(Color.white)
                .padding()

            SecureField("Password", text: $password)
                .background(Color.white)
                .padding([.leading, .trailing, .bottom])

            Button(action: {
                loginHandler.handleLogin(username: username, password: password)
            }, label: {
                Text("Sign In")
            })
            .disabled(buttonDisabled)
            .padding(.bottom)
            
            Spacer()
            
            Button(action: {
                showForm = true
                
            }, label: {
                Text("Don't Have an account? Sign up")
            })
            .sheet(isPresented: $showForm, content: {
                RegisterView(username: $username, email: $email, password: $password, loginHandler: loginHandler)
            })
            .padding(.bottom)
        }
        .frame(width: 400, height: 400)
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let loginHandler = LoginHandler()
        LoginView(loginHandler: loginHandler)
    }
}
