//
// TwitterLoginManager.swift
//
// Created by Ben for NetworkSample on 2021/2/5.
// Copyright © 2021 Alien. All rights reserved.
//

import Foundation
import RxSwift
import NSObject_Rx

class TwitterLoginManager: NSObject {
    func login() {
        let tw = Twitter.RequestToken()
        API.shared.request(tw,resonseType: .queryString)
            .flatMap { (response) -> Single<TwitterAuthorizeResponseModel> in
                dLog(response)
                let request = API.shared.requestOAuthWebFlow(Twitter.Authorize(requestToken: response.oauthToken))
                return request
            }
            .flatMap { (model) -> Single<TwitterAccessTokenResponseModel> in
                dLog(model)
                
                return API.shared.request(Twitter.AccessToken(token: model.oauthToken, verifier: model.oauthVerifier),resonseType: .queryString)
            }

            .subscribe { model in
                dLog(model)
            } onError: { error in
                dLog(error.localizedDescription)
            }.disposed(by: rx.disposeBag)

    }
}
