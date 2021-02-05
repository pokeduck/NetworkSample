//
// GitHubUser.swift
//
// Created by Ben for NetworkSample on 2021/1/27.
// Copyright © 2021 Alien. All rights reserved.
//

import Foundation

struct GitHubAuthorizeResponseModel: Codable {
    let code: String
    let state: String //CSRF
}

struct GitHubAuthTokenResponseModel: Codable {
    let accessToken, scope, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
}

struct GitHubUserResponseModel: Codable {
    let login: String
    let id: Int
    let nodeID: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
    }
}
