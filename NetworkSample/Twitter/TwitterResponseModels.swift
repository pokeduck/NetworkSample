//
// TwitterResponseModels.swift
//
// Created by Ben for NetworkSample on 2021/2/5.
// Copyright © 2021 Alien. All rights reserved.
//

import Foundation

struct TwitterRequestTokenResponseModel: Codable {
    let oauthCallbackConfirmed, oauthToken, oauthTokenSecret: String

    enum CodingKeys: String, CodingKey {
        case oauthCallbackConfirmed = "oauth_callback_confirmed"
        case oauthToken = "oauth_token"
        case oauthTokenSecret = "oauth_token_secret"
    }
}


struct TwitterAuthorizeResponseModel: Codable {
    let oauthToken,oauthVerifier : String
    enum CodingKeys: String, CodingKey {
        case oauthToken = "oauth_token"
        case oauthVerifier = "oauth_verifier"
    }
}

struct TwitterAccessTokenResponseModel: Codable {
    let oauthToken,oauthTokenSecret,userID: String
    enum CodingKeys: String, CodingKey {
        case oauthToken = "oauth_token"
        case oauthTokenSecret = "oauth_token_secret"
        case userID = "user_id"
    }
}
extension TwitterAccessTokenResponseModel: CustomStringConvertible {
    var description: String {
        return "AccessToken:\ntoken:\(oauthToken),secret:\(oauthTokenSecret),userid:\(userID)"
    }
}
extension TwitterRequestTokenResponseModel: CustomStringConvertible {
    var description: String {
        return "RequestToken:\ntoken:\(oauthToken),secret:\(oauthTokenSecret)"
    }
}
extension TwitterAuthorizeResponseModel: CustomStringConvertible {
    var description: String {
        return "Authorize:\ntoken:\(oauthToken),verifier:\(oauthVerifier)"
    }
}


// MARK: - Users
struct TwitterUsersResponseModel: Codable {
    let data: TwitterUsersDataClass
}

// MARK: - DataClass
struct TwitterUsersDataClass: Codable {
    let id, name, username: String
}

struct TwitterVerifyCredentialsResponseModel: Codable {
    let id: Double
    let idStr, name, screenName, email: String

    enum CodingKeys: String, CodingKey {
        case id
        case idStr = "id_str"
        case name
        case screenName = "screen_name"
        case email
    }
}
