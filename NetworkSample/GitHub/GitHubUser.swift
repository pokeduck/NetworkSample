//
// GitHubUser.swift
//
// Created by Ben for NetworkSample on 2021/1/27.
// Copyright © 2021 Alien. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gitHubUser = try GitHubUser(json)

import Foundation

// MARK: - GitHubUser

struct GitHubUserModel: Codable {
    let login: String
    let id: Int
    let nodeID: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
    }
}
