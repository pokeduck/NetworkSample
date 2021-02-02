//
// GitHubLoginManager.swift
//
// Created by Ben for NetworkSample on 2021/2/1.
// Copyright © 2021 Alien. All rights reserved.
//

import UIKit
import AuthenticationServices
import RxSwift
import Moya

final class GitHubLoginManager: NSObject {
    func login() -> Single<GitHubUserModel> {
        
        let authorize = GitHub.Authorize()
        guard let url = authorize.fullURL else {
            return Single<GitHubUserModel>.create { (observe) -> Disposable in
                observe(.error(MoyaError.requestMapping("Error")))
                return Disposables.create {
                    
                }
            }
        }
        return ASWebAuthenticationSession.present(url: url, from: self)
            .flatMap {  (response) -> Single<GitHub.AccessToken.ResponseType> in
                return API.shared.request(GitHub.AccessToken(code: response.code, state: response.state))
            }
            .flatMap { (response) -> Single<GitHub.Users.ResponseType> in
                return API.shared.request(GitHub.Users(token: response.accessToken))
            }
    }
}

extension GitHubLoginManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        return window
    }
    
    
}
