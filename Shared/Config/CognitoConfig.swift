//
//  CognitoConfig.swift
//  Created by David Tucker (davidtucker.net) on 5/4/17.
//
//  Copyright (c) 2017 David Tucker
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import SotoCognitoAuthenticationKit

class CognitoConfig: NSObject {
    
    var keys:Dictionary<String,Any>?
    
    override init() {
        super.init()
        self.keys = readPropertyList()
        guard self.keys != nil else {
            fatalError("You must include a CognitoConfig.plist file with the necesary values for your user pool")
        }
    }
    
    func readPropertyList() -> Dictionary<String,Any>? {
        if let path = Bundle.main.path(forResource: "CognitoConfig", ofType: "plist") {
            let keys = NSDictionary(contentsOfFile: path)
            return keys as? Dictionary<String,Any>
        }
        return nil
    }
    
    func getPoolId() -> String {
        let poolId = self.keys?["poolId"] as? String
        guard poolId != nil else {
            fatalError("You must specify a poolId in your CognitoConfig.plist file")
        }
        return poolId!
    }
    
    func getClientId() -> String {
        let clientId = self.keys?["clientId"] as? String
        guard clientId != nil else {
            fatalError("You must specify a clientlId in your CognitoConfig.plist file")
        }
        return clientId!
    }
    
    func getClientSecret() -> String {
        let clientSecret = self.keys?["clientSecret"] as? String
        guard clientSecret != nil else {
            fatalError("You must specify a clientSecret in your CognitoConfig.plist file")
        }
        return clientSecret!
    }
    
    func getRegion() -> Region {
        let region = self.keys?["region"] as? String
        guard region != nil else {
            fatalError("You must specify a region value in CognitoConfig.plist")
        }
        var output:Region?
        
        switch region! {
            
        case "us-east-1":
            output = .useast1
        case "us-east-2":
            output = .useast2
        case "us-west-1":
            output = .uswest1
        case "us-west-2":
            output = .uswest2
        case "ap-south-1":
            output = .apsouth1
        case "ap-northeast-1":
            output = .apnortheast1
        case "ap-northeast-2":
            output = .apnortheast2
        case "ap-southeast-1":
            output = .apsoutheast1
        case "ap-southeast-2":
            output = .apsoutheast2
        case "ca-central-1":
            output = .cacentral1
        case "cn-north-1":
            output = .cnnorth1
        case "eu-central-1":
            output = .eucentral1
        case "eu-west-1":
            output = .euwest1
        case "eu-west-2":
            output = .euwest2
        case "eu-west-3":
            output = .euwest3
        case "sa-east-1":
            output = .saeast1
        case "us-gov-west-1":
            output = .usgovwest1
        default:
            print("Invalid region specified")
            
        }
        
        guard output != nil else {
            fatalError("You must specify a valid region value in CognitoConfig.plist such as 'us-east-1'")
        }
        
        return output!
    }
    
}
