//
//  LoginView.swift
//  Shared
//
//  Created by Ivan C Myrvold on 02/05/2021.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showForm = false
    @State var newPassword = ""
    @ObservedObject var loginHandler: LoginHandler// = LoginHandler()
    
    var buttonDisabled: Bool {
        showForm == true || username.isEmpty || password.isEmpty
    }
    
    var body: some View {
        ZStack {
            Image("scanface")
                .centerCropped()
                .ignoresSafeArea()
            
            VStack {
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .frame(width: 200, height: 36)
                    .background(Color.white)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .cornerRadius(6)
                    .padding()

                SecureField("Password", text: $password)
                    .frame(width: 200, height: 36)
                    .background(Color.white)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .cornerRadius(6)
                    .padding(.bottom)

                Button(action: {
                    loginHandler.handleLogin(username: username, password: password)
                }, label: {
                    Text("Sign In")
                        .frame(width: 200, height: 36)
                        .background(Color.green)
                        .padding(.top)
                })
                .disabled(buttonDisabled)
                .cornerRadius(6)
                .padding(.bottom)
            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    showForm = true
                    
                }, label: {
                    Text("Don't Have an account? Sign up")
                        .foregroundColor(.white)
                })
                .sheet(isPresented: $showForm, content: {
                    RegisterView(username: $username, email: $email, password: $password, loginHandler: loginHandler)
                })
            }
            
            BottomSheetView(isOpen: $loginHandler.challenged, maxHeight: 400) {
                
                VStack {
                    Text("You must change your password")
                        .font(.headline)
                        .padding(.bottom)
                    
                    TextField("New password", text: $newPassword)
                    
                    Button("Change password") {
                        loginHandler.handleChallenge(with: newPassword)
                    }
                    .disabled(newPassword.isEmpty)
                }
                .padding()
            }
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let loginHandler = LoginHandler()
        LoginView(loginHandler: loginHandler)
    }
}

