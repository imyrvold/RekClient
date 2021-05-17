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
    @State private var verificationCode = ""
    @State private var showForm = false
    @State var newPassword = ""
    @ObservedObject var loginHandler: LoginHandler
    
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
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                .sheet(isPresented: $loginHandler.confirmSignup, content: {
                    ConfirmView(username: username, loginHandler: loginHandler)
                })
                .sheet(isPresented: $loginHandler.challenged, content: {
                    ChallengeView(loginHandler: loginHandler)
                })
            }
            
            ErrorSheetView(isOpen: $loginHandler.error, maxHeight: 250) {
                VStack {
                    HStack {
                        Image(systemName: "xmark.octagon.fill")
                            .renderingMode(.original)

                        Text("Error!")
                    }
                    .font(.title)
                    .padding([.bottom, .top])

                    Text(loginHandler.errorText)
                        .font(.footnote)
                        .padding()

                    Spacer()
                    
                    Button("Cancel") {
                        loginHandler.cancelError()
                    }
                    .padding(.bottom, 70)
                }
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

