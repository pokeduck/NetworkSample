//
// API.swift
//
// Created by Ben for NetworkSample on 2021/2/1.
// Copyright © 2021 Alien. All rights reserved.
//

import Foundation
import RxSwift
import Moya

final class API {
    static let shared = API()
    
    private init() {}
    
    private let provider = MoyaProvider<MultiTarget>()
    
    func request<Request: DecodeResponseTargetType>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget(request)
        let newSingle =
            provider.rx
            .request(target)
            .filterSuccessfulStatusCodes()
//            .map { (response) -> Request.ResponseType in
//                let decoder = JSONDecoder()
//                let data = try decoder.decode(Request.ResponseType.self, from: response.data)
//                dLog(data)
//                let responseBody = String(data: response.data, encoding: .utf8)
//                dLog(responseBody)
//                return Request.ResponseType(from: response.data, using: .init())!
//            }
            .map(Request.ResponseType.self)
        return newSingle
    }
}

