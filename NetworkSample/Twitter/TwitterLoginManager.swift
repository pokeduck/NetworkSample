//
// TwitterLoginManager.swift
//
// Created by Ben for NetworkSample on 2021/2/5.
// Copyright © 2021 Alien. All rights reserved.
//

import Foundation
import RxSwift
import NSObject_Rx
///https://oauth.net/core/1.0/#anchor9
///https://developer.twitter.com/en/docs/authentication/oauth-1-0a/obtaining-user-access-tokens
class TwitterLoginManager: NSObject {
    func login() {
        let tw = Twitter.RequestToken()
        API.request(tw,resonseType: .queryString)
            .flatMap { (response) -> Single<TwitterAuthorizeResponseModel> in
                dLog(response)
                let request = API.requestOAuthWebFlow(Twitter.Authorize(requestToken: response.oauthToken))
                return request
            }
            .flatMap { (model) -> Single<TwitterAccessTokenResponseModel> in
                dLog(model)
                return API.request(Twitter.AccessToken(token: model.oauthToken, verifier: model.oauthVerifier),resonseType: .queryString)
            }
            .flatMap({ (model) -> Single<TwitterVerifyCredentialsResponseModel> in
                dLog(model)
                twitterToken.oauthToken = model.oauthToken
                twitterToken.oauthTokenSecret = model.oauthTokenSecret
                return API.request(Twitter.VerifyCredentials())
            })

            .subscribe { model in
                dLog(model)
            } onError: { error in
                dLog(error.localizedDescription)
            }.disposed(by: rx.disposeBag)

    }
}
