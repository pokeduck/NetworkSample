//
// TwitterRequestModels.swift
//
// Created by Ben for NetworkSample on 2021/2/2.
// Copyright © 2021 Alien. All rights reserved.
//

import Moya
import OAuthSwift

struct TwitterToken: Codable {
    let name: String
}

protocol TwitterApiTargetType: DecodeResponseTargetType,AccessTokenAuthorizable {}

extension TwitterApiTargetType {
    var baseURL: URL { URL(string: "https://api.twitter.com")! }
    
    var authorizationType: AuthorizationType? { .custom("OAuth") }

    var sampleData: Data { Data() }

}
enum TwitterKey {
    //https://developer.twitter.com/en/docs/authentication/overview
    enum V1 { //[STANDALONE]NetworkSampleDev01
        static private let key = "7btmkz4leL5tVdjsqWc7ra25l" //oauth1.0a
        static private let secret = "I3hyeYlqxDZe5htWJAgHnY5yGWKWIvMvsdHdD827swxxbz9TVF" //oauth1.0a
        static private let bearerToken = "AAAAAAAAAAAAAAAAAAAAAE1nMQEAAAAA5pdH%2BwSwzPqZ4WrZ5olwIU0aIWM%3D0ohpko4rsYrV2HoxHIoGLW5tV1DfggNi7OZ4Hgvi8HJtslkSBk" //oauth2.0
    }
    enum V2 {
        static let key = "6wKxqrWpyIc1bToXS5Ox5pbTm" //oauth1.0a
        static let keySecret = "ksStbWQUMW4ZFRkbDK8w08bs31Nki8V7WMuUh8AWMZJvj2Y502" //oauth1.0a
        static let token = "1319551343904780291-2SkViug1K4ok0vFgRw6FIt845wCij1"
        static let tokenSecret = "ewruzNtTmaJschm75Iwmp09Dp0fbuxV30RvSztLQuxtMZ"
        static let bearerToken = "AAAAAAAAAAAAAAAAAAAAAL54JAEAAAAAbi5dv43BMJLVJnOIoXPz3w1l21Q%3DcDKMiDGsJOGWjSjSp5xMd0PX8JWsSbcRcX6qoIj9FVF0s3ftAY" //oauth2.0
    }
}
enum Twitter {
    struct RequestToken: TwitterApiTargetType {
        
        
        typealias ResponseType = TwitterRequestTokenResponseModel
        
        var path: String = "/oauth/request_token"
        
        var method: Moya.Method = .post
                
        var task: Task {
            .requestPlain
        }
        
        var headers: [String : String]? {
            return credential()
        }
        
        private func credential() -> [String : String] {
            let credential = OAuthSwiftCredential(consumerKey: TwitterKey.V2.key, consumerSecret: TwitterKey.V2.keySecret)
            let header =  credential.makeHeaders(baseURL.appendingPathComponent(path), method: .POST, parameters: ["oauth_callback":"networksampledev://"])
            return header
        }
    }
    
    struct Authorize: TwitterApiTargetType,DecodeResponseAuthTargetType {
        var oAuthURL: URL {
            let newURL = baseURL
            return newURL.appendingPathComponent(path).appendingQueryParameters(["oauth_token":requestToken])
        }
        
        typealias ResponseType = TwitterAuthorizeResponseModel
        
        var authorizationType: AuthorizationType?
        
        var path: String { "/oauth/authorize"}
        
        var method: Moya.Method { .get }
        
        var task: Task { .requestPlain }
        
        var headers: [String : String]? { return nil }
        
        var fullURL:URL {
            let newURL = baseURL
            return newURL.appendingPathComponent(path).appendingQueryParameters(["oauth_token":requestToken])
        }
        
        let requestToken: String
        
        init(requestToken: String) {
            self.requestToken = requestToken
        }
    }
    
    
    struct AccessToken: TwitterApiTargetType {
        typealias ResponseType = TwitterAccessTokenResponseModel
        
        var path: String { "/oauth/access_token" }
        
        var method: Moya.Method { .post }
        
        var task: Task {
            .requestParameters(parameters:
                                ["oauth_token": oauthToken,
                                 "oauth_verifier": oauthVerifier], encoding: URLEncoding.default)
        }
        
        var headers: [String : String]?
        
        let oauthToken,oauthVerifier: String
        
        init(token:String, verifier: String) {
            self.oauthToken = token
            self.oauthVerifier = verifier
        }
    }
}



//Response

//oauth_token=6253282-eWudHldSbIaelX7swmsiHImEL4KinwaGloHANdrY&oauth_token_secret=2EEfA6BG5ly3sR3XjE0IBSnlQu4ZrUzPiYTmrkVU&user_id=6253282&screen_name=twitterapi
