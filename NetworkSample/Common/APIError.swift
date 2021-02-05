//
// APIError.swift
//
// Created by Ben for NetworkSample on 2021/2/5.
// Copyright © 2021 Alien. All rights reserved.
//

import Foundation

enum WebFlowAuthError: Swift.Error {
    case decodeQuery
    case stringMapping
}
extension WebFlowAuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodeQuery:
            return "Query string not found."
        case .stringMapping:
            return "Mapping string failed."
        }
        
    }
}
