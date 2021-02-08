//
// GitHubLoginManager.swift
//
// Created by Ben for NetworkSample on 2021/2/1.
// Copyright © 2021 Alien. All rights reserved.
//

import Foundation
import RxSwift

final class GitHubLoginManager: NSObject {
    func login() {//-> Single<GitHubUserModel> {
        
        API.requestOAuthWebFlow(GitHub.Authorize()).flatMap { (model) -> Single<GitHub.AccessToken.ResponseType> in
            dLog(model)
            return API.request(GitHub.AccessToken(code: model.code, state: model.state))
        }.flatMap { (model) -> Single<GitHub.Users.ResponseType> in
            dLog(model)
            return API.request(GitHub.Users(token: model.accessToken))
        }.subscribe { (model) in
            dLog(model)
        } onError: { (error) in
            dLog(error.localizedDescription)
        }.disposed(by: rx.disposeBag)
    }
}
