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
import AuthenticationServices


extension WebFlowAuthError: CustomNSError {
    var errorCode: Int {
        return 0
    }
    
}

protocol DecodeResponseTargetType: TargetType {
    associatedtype ResponseType: Decodable
}
protocol DecodeResponseAuthTargetType: DecodeResponseTargetType {
    var oAuthURL: URL { get }
}

final class API: NSObject {
    static let shared = API()
    
    private override init() {}
    
    private let provider = MoyaProvider<MultiTarget>()
    
    func request<Request: DecodeResponseTargetType>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget(request)
        let newSingle =
            provider.rx
            .request(target)
            .filterSuccessfulStatusCodes()
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
                    
                    let data = try JSONSerialization.data(withJSONObject: newDict, options: .prettyPrinted)
                    
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(Request.ResponseType.self, from: data)
                    
                    return model
                } catch let error{
                    dLog(error.localizedDescription)
                    throw MoyaError.jsonMapping(response)
                }
                
            }
        return newSingle
    }
    
    func requestOAuthWebFlow<R: DecodeResponseAuthTargetType>(_ request: R) -> Single<R.ResponseType> {
        return Single.create { (single) -> Disposable in
            let session = ASWebAuthenticationSession(url: request.oAuthURL, callbackURLScheme: nil) { (url, error) in
                if let error = error {
                    single(.error(error))
                    return
                }
                guard let queryDic = url?.queryParameters else {
                    single(.error(WebFlowAuthError.decodeQuery))
                    return
                }
                do {
                    let data = try JSONSerialization.data(withJSONObject: queryDic, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(R.ResponseType.self, from: data)
                    single(.success(model))
                    return
                } catch {
                    single(.error(WebFlowAuthError.stringMapping))
                    return
                }
                
            }
            
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
            session.start()
            
            return Disposables.create {
                session.cancel()
            }
        }
    }
}


extension API: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first!
        return window
    }
}
