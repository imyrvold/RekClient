//
//  LoginHandler.swift
//  RekClient
//
//  Created by Ivan C Myrvold on 02/05/2021.
//

import Foundation
import SotoCognitoAuthenticationKit
import SotoCognitoIdentityProvider
import SotoCognitoIdentity
import Combine
import KeychainSwift

class LoginHandler: ObservableObject {
    struct Constants {
        static var AccessToken = "AccessToken"
        static var RefreshToken = "RefreshToken"
        static var User = "user"
    }

    lazy var awsClient = AWSClient(credentialProvider: .empty, httpClientProvider: .createNew)
    lazy var cognitoIdentityProvider = CognitoIdentityProvider(client: awsClient, region: .euwest1)
    lazy var configuration: CognitoConfiguration = {
        let poolId = cognitoConfig.getPoolId()
        let clientSecret = cognitoConfig.getClientSecret()
        let clientId = cognitoConfig.getClientId()
        let region: Region = cognitoConfig.getRegion()
        let cognitoIdentityProvider = CognitoIdentityProvider(client: awsClient, region: region)
        
       return CognitoConfiguration(userPoolId: poolId, clientId: clientId, clientSecret: clientSecret, cognitoIDP: cognitoIdentityProvider)
    }()
    lazy var authenticatable = CognitoAuthenticatable(configuration: configuration)
    lazy var cognitoConfig = CognitoConfig()
    @Published var challenged = false
    @Published var authenticated = false
    var challenge: CognitoAuthenticateResponse.ChallengedResponse?
    var username: String?
    let keychain = KeychainSwift()
    
    func handleLogin(username: String, password: String) {
        print("LoginHandler handleLogin", Date())
        let data = AWSCognitoContext()
        let response = self.authenticatable.authenticate(
            username: username,
            password: password,
            requireAuthenticatedClient: false,
            clientMetadata: nil,
            context: data,
            on: authenticatable.configuration.cognitoIDP.eventLoopGroup.next()
        )
        self.username = username

        response.whenComplete { result in
            self.handleAuthentication(with: result)
        }
    }
    
    func handleChallenge(with newPassword: String) {
        print("LoginHandler handleChallenge newPassword:", newPassword)
        self.challenged = false
        guard let challenge = self.challenge, let session = challenge.session, let username = self.username else { return }
        let data = AWSCognitoContext()
        print("LoginHandler handleChallenge challenge.name:", challenge.name)
        if challenge.name == CognitoChallengeName.newPasswordRequired.rawValue {
            let challengeName: CognitoChallengeName = .newPasswordRequired
            let challengeResponse = ["NEW_PASSWORD": newPassword]
            
            let newPasswordResponse = self.authenticatable.respondToChallenge(
                username: username,
                name: challengeName,
                responses: challengeResponse,
                session: session,
                requireAuthenticatedClient: false,
                context: data,
                on: self.authenticatable.configuration.cognitoIDP.eventLoopGroup.next()
            )

            newPasswordResponse.whenComplete { result in
                self.handleAuthentication(with: result)
            }

        }
    }
    
    func handleAuthentication(with result: Result<CognitoAuthenticateResponse, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .failure(let error):
                print("LoginHandler handleAuthentication failure error:", error)
            case .success(let response):
                switch response {
                case .authenticated(let authenticatedResponse):
                    print("LoginHandler handleAuthentication authenticated authenticatedResponse:", authenticatedResponse)
                    self.authenticated = true
                    self.handleAuthentication(with: authenticatedResponse)
                case .challenged(let challengedResponse):
                    print("LoginHandler handleAuthentication authenticated challengedResponse:", challengedResponse)
                    self.challenged = true
                    self.challenge = challengedResponse
                }
            }
        }
    }
    
    func handleAuthentication(with response: CognitoAuthenticateResponse.AuthenticatedResponse) {
        if let accessToken = response.accessToken {
            keychain.set(accessToken, forKey: Constants.AccessToken)
        }
        if let refreshToken = response.refreshToken {
            keychain.set(refreshToken, forKey: Constants.RefreshToken)
        }
    }

    func registerUser(username: String, email: String, password: String) {
        let attributes: [String: String] = ["username": username, "email": email, "password": password]

//        let response = authenticatable.createUser(username: username, attributes: attributes, temporaryPassword: password)
        let response = authenticatable.signUp(username: username, password: password, attributes: attributes)
        
        response.whenComplete { result in
            switch result {
            case .failure(let error):
                print("LoginHandler registerUser error:", error)
            case .success(let userResponse):
                let userConfirmed = userResponse.userConfirmed
                let userSub = userResponse.userSub
                
                print("userConfirmed:", userConfirmed, " userSub:", userSub)
            }
        }
    }
    
    func checkToken() {
        guard let token = keychain.get(Constants.AccessToken) else { return }

        let response = authenticatable.authenticate(accessToken: token, on: authenticatable.configuration.cognitoIDP.eventLoopGroup.next())
        
        response.whenComplete { result in
            switch result {
            case .failure(_):
                self.refreshToken()
            case .success(_):
                DispatchQueue.main.async {
                    self.authenticated = true
                }
            }
        }
    }
    
    func refreshToken() {
        guard let refreshToken = keychain.get(Constants.RefreshToken), let username = self.username else { return }
        let response = authenticatable.refresh(username: username, refreshToken: refreshToken, requireAuthenticatedClient: false)

        response.whenComplete { result in
            switch result {
            case .failure(let error):
                print("LoginHandler refreshToken failure:", error)
                DispatchQueue.main.async {
                    self.authenticated = false
                }
            case .success(let response):
                switch response {
                case .authenticated(let authenticatedResponse):
                    DispatchQueue.main.async {
                        self.authenticated = true
                    }
                    self.handleAuthentication(with: authenticatedResponse)
                case .challenged(let challengedResponse):
                    self.challenged = true
                    self.challenge = challengedResponse
                }
            }
        }
    }
}

class AWSCognitoContext: CognitoContextData {
    var contextData: CognitoIdentityProvider.ContextDataType? {
        return CognitoIdentityProvider.ContextDataType(
            httpHeaders: [],
            ipAddress: "",
            serverName: "",
            serverPath: "")
    }
}
