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

struct AuthToken: Codable {
    let accessToken, scope, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
}

// {"access_token":"e72e167e42f292c6912e7710c838347ae178b4a", "scope":"repo,gist", "token_type":"bearer"}

extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
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
    private static let redirectURI: String = "networksampledev://"
    private static let clientID: String = "a8219e70df1fad20ea32"
    private static let clientSecret: String = "3bf810107e9a41f5641c6eb8eda982382ebc21d6"
    struct Authorize: GitHubApiTargetType {
        typealias ResponseType = Profile

        var baseURL = URL(string: "https://github.com")!

        var path: String = "/login/oauth/authorize"

        var method: Method = .get

        var sampleData = Data()

        var task: Task {
            .requestParameters(parameters: headers ?? [:], encoding: URLEncoding.default)
        }


        var headers: [String: String]? =
            [
                "client_id": clientID,
                "redirect_uri": redirectURI,
                "scpoe": "read:user",
                "allow_signup": "true",
                "state": UUID().uuidString,
            ]
        // https://github.com/login/oauth/authorize?redirect_uri=networksample://redirect&allow_signup=false&scpoe=repo,user:email&state=abcd
        var fullURL: URL? {
            guard let headerDict = headers else { return nil }
            var combinePath: String = baseURL.absoluteString + path
            var argCnt = 0
            combinePath += ""
            for (key, val) in headerDict {
                if argCnt == 0 {
                    combinePath += "?"
                } else {
                    combinePath += "&"
                }
                argCnt += 1
                combinePath += "\(key)=\(val)"
            }
            guard let path_ = combinePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: path_)
            else {
                return nil
            }
            return url
        }
    }

    struct AccessToken: GitHubApiTargetType {
        typealias ResponseType = AuthToken

        var baseURL = URL(string: "https://github.com")!

        var path: String = "/login/oauth/access_token"

        var method: Method = .post

        var sampleData: Data {
            let path = Bundle.main.path(forResource: "AccessToken", ofType: "json")!
            return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
        }

        var task: Task {
            .requestParameters(parameters: headers ?? [:], encoding: URLEncoding.default)
        }

        var headers: [String: String]? {
            [
                "client_id": clientID,
                "client_secret": clientSecret,
                "code": code,
                "redirect_uri": redirectURI,
                "state": state,
                "Accept": "application/json",
            ]
        }

        private let code: String
        private let state: String
        init(code: String, state: String) {
            self.code = code
            self.state = state
        }
    }

    struct Users: GitHubApiTargetType {
        typealias ResponseType = GitHubUserModel

        var path: String = "/user"

        var method: Method = .get

        var sampleData: Data {
            let path = Bundle.main.path(forResource: "GitHubUser", ofType: "json")!
            return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
        }

        var task: Task {
            .requestParameters(parameters: headers ?? [:], encoding: URLEncoding.default)
        }

        var headers: [String: String]? {
            ["Authorization": "Bearer \(token)"]
        }

        private let token: String

        init(token: String) {
            self.token = token
        }
    }
}
