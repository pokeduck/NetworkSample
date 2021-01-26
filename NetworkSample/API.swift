//
// API.swift
//
// Created by Ben for NetworkSample on 2021/1/26.
// Copyright © 2021 Alien. All rights reserved.
//

import Moya

struct Profile: Codable {
    let name: String
}

struct Token: Codable {
    let token: String
    let scpoe: String
    let type: String
}


//{"access_token":"e72e16c7e42f292c6912e7710c838347ae178b4a", "scope":"repo,gist", "token_type":"bearer"}

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}

protocol DecodeResponseTargetType: TargetType {
    associatedtype ResponseType: Decodable
}

protocol GitHubApiTargetType: DecodeResponseTargetType {}

extension GitHubApiTargetType {
    var baseURL: URL { URL(string: "https://api.github.com")! }
}

enum GitHub {
    private static let redirectURI:String = "networksampledev://"
    private static let clientID: String = "a8219e70df1fad20ea32"
    private static let clientSecret: String = "3bf810107e9a41f5641c6eb8eda982382ebc21d6"
    struct Authorize: GitHubApiTargetType {
        
        typealias ResponseType = Profile
        
        var baseURL: URL = URL(string: "https://github.com")!
        
        var path: String = "/login/oauth/authorize"
        
        var method: Method = .get
        
        var sampleData: Data = Data()
        
        var task: Task {
            .requestParameters(parameters: headers ?? [:], encoding: URLEncoding.default )
        }
        //screct = "3bf810107e9a41f5641c6eb8eda982382ebc21d6"
        var headers: [String : String]? =
            [
                "client_id" : clientID,
                "redirect_uri": redirectURI,
                "scpoe": "repo,user:email",
                "allow_signup": "true",
                "state": UUID().uuidString
            ]
        //https://github.com/login/oauth/authorize?redirect_uri=networksample://redirect&allow_signup=false&scpoe=repo,user:email&state=abcd

    }
    
    struct AccessToken: GitHubApiTargetType {
        typealias ResponseType = Token
        
        var path: String = "/oauth/access_token"
        
        var method: Method = .post
        
        var sampleData: Data {
            let path = Bundle.main.path(forResource: "AccessToken", ofType: "json")!
            return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
        }
        
        var task: Task {
            .requestParameters(parameters: headers ?? [:], encoding: URLEncoding.default
            )
        }
        var headers: [String : String]? {
            [
                "client_id": clientID,
                "client_secret": clientSecret,
                "code":code,
                "redirect_uri":redirectURI,
                "state":state,
                "Accept": "application/json"
            ]
        }
        
        private let code: String
        private let state: String
        init(code: String, state: String) {
            self.code = code
            self.state = state
        }
    }
}

