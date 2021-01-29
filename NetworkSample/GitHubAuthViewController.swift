//
// GitHubAuthViewController.swift
//
// Created by Ben for NetworkSample on 2021/1/27.
// Copyright © 2021 Alien. All rights reserved.
//

import WebKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit
import RxWebKit
import AuthenticationServices

final class GitHubAuthViewController: UIViewController {
    private let bag = DisposeBag()
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .fullScreen
    }

    private lazy var webView: GitHubAuthWebView = {
        let web = GitHubAuthWebView()
        view.addSubview(web)
        web.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        return web
    }()

    private lazy var topBar: GitHubAuthTopView = {
        let v = GitHubAuthTopView(frame: .zero)
        view.addSubview(v)
        v.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(60)
        }
        return v
    }()

    private lazy var preBtn: UIBarButtonItem = {
        let b = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(pressPre))
        return b
    }()

    private lazy var nextBtn: UIBarButtonItem = {
        let b = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(pressNext))
        return b
    }()

    private lazy var toolView: UIToolbar = {
        let v = UIToolbar(frame: .zero)
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        v.items = [preBtn, fixedSpace, nextBtn, flexSpace, nextBtn]
        view.addSubview(v)
        v.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        return v

    }()

    @objc private func pressPre() {}

    @objc private func pressNext() {}

    override func viewDidLoad() {
        super.viewDidLoad()
//        _ = toolView
        _ = topBar
        view.backgroundColor = .white
        _ = webView

        topBar.cancelBtn.rx.tap.subscribe { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: bag)
        
        webView.rx.decidePolicyNavigationAction.subscribe { ( webView: WKWebView, action: WKNavigationAction, handler: ((WKNavigationActionPolicy) -> Void)) in
            dLog(webView.url?.scheme ?? "")
            if let reqPath = action.request.url?.absoluteString,
               let components = URLComponents(string: reqPath) {
                let schcme = components.scheme ?? ""
                let queryItems = components.queryItems
                //dLog("Scheme:\(schcme)")
                dLog(action.request.url?.absoluteString ?? "")
                if schcme == "networksampledev" {
                    handler(.cancel)
                    return
                    
                }
            }
            
            handler(.allow)
        }.disposed(by: bag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadAuth()
    }

    func loadAuth() {
        let authorize = GitHub.Authorize()

        guard let headerDict = authorize.headers else { return }
        var path: String = authorize.baseURL.absoluteString + authorize.path
        var argCnt = 0
        for (key, val) in headerDict {
            if argCnt == 0 {
                path += "?"
            } else {
                path += "&"
            }
            argCnt += 1
            path += "\(key)=\(val)"
        }
        guard let path_ = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let path_encode = path_.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: path_encode)
        else {
            return
        }
        webView.loadURL(url: url)
    }
}

extension ASWebAuthenticationSession {
    static func present(url: URL,from vc: ASWebAuthenticationPresentationContextProviding, resultHandler:@escaping ASWebAuthenticationSession.CompletionHandler) {
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: nil, completionHandler: resultHandler)
        session.presentationContextProvider = vc
        session.prefersEphemeralWebBrowserSession = false
        session.start()
    }
}
