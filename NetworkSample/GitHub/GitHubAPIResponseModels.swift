//
// GitHubUser.swift
//
// Created by Ben for NetworkSample on 2021/1/27.
// Copyright © 2021 Alien. All rights reserved.
//

import Foundation

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

struct GitHubUserModel: Codable {
    let login: String
    let id: Int
    let nodeID: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
    }
}


extension GitHubUserModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GitHubUserModel.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        login: String? = nil,
        id: Int? = nil,
        nodeID: String? = nil
    ) -> GitHubUserModel {
        return GitHubUserModel(
            login: login ?? self.login,
            id: id ?? self.id,
            nodeID: nodeID ?? self.nodeID
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
