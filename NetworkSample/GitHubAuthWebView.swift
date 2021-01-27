//
// GitHubAuthWebView.swift
//
// Created by Ben for NetworkSample on 2021/1/27.
// Copyright © 2021 Alien. All rights reserved.
//

import WebKit

final class GitHubAuthWebView: WKWebView {
    init() {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.default()
        super.init(frame: .zero, configuration: config)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadURL(url: URL) {
        let req = URLRequest(url: URL(string: "https://google.com")!)
        load(req)
    }
}

extension GitHubAuthWebView: WKUIDelegate {}

extension GitHubAuthWebView: WKNavigationDelegate {}
