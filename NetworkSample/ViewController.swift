//
// ViewController.swift
//
// Created by Ben for NetworkSample on 2021/1/26.
// Copyright © 2021 Alien. All rights reserved.
//


import SafariServices
import UIKit
import WebKit
import FLEX
import AuthenticationServices
import SwifterSwift
import Moya
import RxSwift
import NSObject_Rx

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    let githubLoginManager = GitHubLoginManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton()
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.setTitle("Go", for: .normal)
        btn.addTarget(self, action: #selector(go), for: .touchUpInside)
        btn.frame = CGRect(x: 30, y: 30, width: 100, height: 100)
        view.addSubview(btn)
        
        
        
//        let ringtonPath = Bundle.main.path(forResource: "morning", ofType: "wav")!
//        let bundleRingUrl = URL(fileURLWithPath: ringtonPath)
//        let path = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
//        let url = path[0].appendingPathComponent("Sounds", isDirectory: true)
//        let targetURL = url.appendingPathComponent("morning.wav")
//        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
//        try? FileManager.default.removeItem(at: targetURL)
//        try? FileManager.default.copyItem(at: bundleRingUrl, to: targetURL)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @objc func go() {
        
        let tw = Twitter.RequestToken()
        dLog(tw.headers)
        API.shared.requestTwitterOAuth(tw)
            .flatMap { (response) -> Single<TwitterAuthorizeResponseModel> in
            return ASWebAuthenticationSession.presentTwitter(url: Twitter.Authorize(requestToken: response.oauthToken).fullURL, from: self)
        }
            .flatMap({ (model) -> Single<TwitterAccessTokenResponseModel> in
                API.shared.requestTwitterOAuth(Twitter.AccessToken(token: model.oauthToken, verifier: model.oauthVerifier))
            })
        
        
        .subscribe { (model) in
            dLog(model.oauthToken)
        } onError: { (error) in
            dLog(error.localizedDescription)
        }.disposed(by: rx.disposeBag)


//        API.shared.requestTwitterOAuth(tw).subscribe { (response) in
//            dLog(response.oauthToken)
//        } onError: { (error) in
//            dLog(error.localizedDescription)
//        }.disposed(by: rx.disposeBag)

//        FLEXManager.shared.showExplorer()
//        githubLoginManager.login().subscribe { (model) in
//            dLog(model.id)
//        } onError: { (error) in
//            dLog(error.localizedDescription)
//        }.disposed(by: rx.disposeBag)
        return
//        present(GitHubAuthViewController(), animated: true, completion: nil)
        //fetchCookies()

         //login(from: self)
    }
    private let accessTokenTrigger = PublishSubject<AuthResponse>()
    func login(from vc: UIViewController) {
        let authorize = GitHub.Authorize()
        guard let url = authorize.fullURL else { return }
        
        let codeRequest = ASWebAuthenticationSession.present(url: url, from: self)
        
        let tokenReq = codeRequest.flatMap { (response) -> Single<GitHub.AccessToken.ResponseType> in
            return API.shared.request(GitHub.AccessToken(code: response.code, state: response.state))
        }
        let userProfileReq = tokenReq.flatMap { (response) -> Single<GitHub.Users.ResponseType> in
            return API.shared.request(GitHub.Users(token: response.accessToken))
        }
        
        userProfileReq.subscribe { (response) in
            dLog(response.id)
        } onError: { (error) in
            dLog(error.localizedDescription)
        }.disposed(by: disposeBag)

        return
        return
//        UIApplication.shared.open(url, options: [:]) { _ in }
        let auth = ASWebAuthenticationSession(url: authorize.fullURL!, callbackURLScheme: nil) { (url, error) in
            
            
        }
        auth.prefersEphemeralWebBrowserSession = true
        auth.presentationContextProvider = self
        //auth.start()
//        let sfvc = SFAuthenticationSession(url: url, callbackURLScheme: "networksampledev://") { (url, error) in
//
//        }
//        sfauth = sfvc
//        sfauth.start()
//        let config = SFSafariViewController.Configuration()
//        config.barCollapsingEnabled = false
//        config.entersReaderIfAvailable = false
//        let safariVC = SFSafariViewController(url: url, configuration: config)
//        safariVC.delegate = self
//        safariVC.dismissButtonStyle = .cancel
//        safariVC.modalPresentationStyle = .automatic
//        vc.present(safariVC, animated: true, completion: nil)
        
    }

    func fetchCookies() {
        let store = WKWebsiteDataStore.default()
        store.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                print("CookieName:\(record.displayName)")
                if record.displayName.contains("github") {
                    store.removeData(ofTypes: record.dataTypes, for: [record]) {
                        dLog("Remove Cookie Success:\(record.displayName)")
                    }
                }
                
            }
        }
    }
}

extension ViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        funcLog()
    }

    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        funcLog()
    }

    func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
        funcLog()
    }

    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        funcLog()
    }

    func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
        funcLog()
        return [UIActivity()]
    }

    func safariViewController(_ controller: SFSafariViewController, excludedActivityTypesFor URL: URL, title: String?) -> [UIActivity.ActivityType] {
        funcLog()
        return [UIActivity.ActivityType(rawValue: "")]
    }
}

extension ViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        return window
    }
    
    
}
