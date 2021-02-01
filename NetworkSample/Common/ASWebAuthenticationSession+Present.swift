//
// ASWebAuthenticationSession+Present.swift
//
// Created by Ben for NetworkSample on 2021/2/1.
// Copyright © 2021 Alien. All rights reserved.
//

import AuthenticationServices
import RxSwift

struct AuthResponse {
    let code: String
    let state: String //CSRF
}
extension ASWebAuthenticationSession {
    static func present(url: URL,from vc: ASWebAuthenticationPresentationContextProviding) -> Single<AuthResponse> {
        return Single.create { (single) -> Disposable in
            
            let session = ASWebAuthenticationSession(url: url,callbackURLScheme: nil) { (url, error) in
                if let error = error {
                    single(.error(error))
                    return
                }
                
                if let code = url?.queryParameters?["code"],
                   let state = url?.queryParameters?["state"] {
                    single(.success(AuthResponse(code: code, state: state)))
                }
            }
            
            session.presentationContextProvider = vc
            session.prefersEphemeralWebBrowserSession = true
            session.start()
            
            return Disposables.create {
                session.cancel()
            }
        }
    }
}


