//
// API.swift
//
// Created by Ben for NetworkSample on 2021/2/1.
// Copyright © 2021 Alien. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import OAuthSwift

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
    func requestTwitterOAuth<Request: DecodeResponseTargetType>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget(request)
        let newSingle =
            provider.rx
            .request(target)
            .filterSuccessfulStatusCodes()
            .map { (response) -> Request.ResponseType in
                do {
                    let str = String(data: response.data, encoding: .utf8) ?? ""
                    let newDict = str.parametersFromQueryString
                    //let newResp = Response(statusCode: response.statusCode, data: newData, request: response.request, response: response.response)
                    
                    let data = try JSONSerialization.data(withJSONObject: newDict, options: .prettyPrinted)
                    
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(Request.ResponseType.self, from: data)
                    
                    return model
                } catch let error{
                    dLog(error.localizedDescription)
                    throw MoyaError.jsonMapping(response)
                }
                
            }
//            .mapQueryString(Request.ResponseType.self)
            //.map(Request.ResponseType.self)
        return newSingle
    }
}

