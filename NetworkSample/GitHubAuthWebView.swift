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
//        uiDelegate = self
//        navigationDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadURL(url: URL) {
        let req = URLRequest(url: url)
        load(req)
    }
}

extension GitHubAuthWebView: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        dLog(webView.url?.scheme ?? "")
        if let reqPath = navigationAction.request.url?.absoluteString,
           let components = URLComponents(string: reqPath) {
            let schcme = components.scheme ?? ""
            let queryItems = components.queryItems
            dLog("Scheme:\(schcme)")
        }
        return webView
    }

    
    func webViewDidClose(_ webView: WKWebView) {
        dLog(webView.url?.scheme ?? "")
    }

    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        dLog(webView.url?.scheme ?? "")
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        dLog(webView.url?.scheme ?? "")
    }

    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        dLog(webView.url?.scheme ?? "")
    }

    
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKContextMenuElementInfo) -> Bool {
        dLog(webView.url?.scheme ?? "")
        return true
    }

    
    func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        dLog(webView.url?.scheme ?? "")
        return nil
    }

    
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
        dLog(webView.url?.scheme ?? "")
    }

    
    func webView(_ webView: WKWebView, contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
        dLog(webView.url?.scheme ?? "")
    }

    
    
    func webView(_ webView: WKWebView, contextMenuWillPresentForElement elementInfo: WKContextMenuElementInfo) {
        dLog(webView.url?.scheme ?? "")
    }

    
    
    func webView(_ webView: WKWebView, contextMenuForElement elementInfo: WKContextMenuElementInfo, willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating) {
        dLog(webView.url?.scheme ?? "")
    }

    
    
    func webView(_ webView: WKWebView, contextMenuDidEndForElement elementInfo: WKContextMenuElementInfo) {
        dLog(webView.url?.scheme ?? "")
    }
}

extension GitHubAuthWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        dLog(webView.url?.scheme ?? "")
        if let reqPath = navigationAction.request.url?.absoluteString,
           let components = URLComponents(string: reqPath) {
            let schcme = components.scheme ?? ""
            let queryItems = components.queryItems
            dLog("Scheme:\(schcme)")
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void)  {
        dLog(webView.url?.scheme ?? "")
        if let reqPath = navigationAction.request.url?.absoluteString,
           let components = URLComponents(string: reqPath) {
            let schcme = components.scheme ?? ""
            let queryItems = components.queryItems
            dLog("Scheme:\(schcme)")
        }
        
        decisionHandler(.allow,preferences)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        dLog(webView.url?.scheme ?? "")
        decisionHandler(.allow)
    }

    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        dLog(webView.url?.scheme ?? "")
    }

    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        dLog(webView.url?.scheme ?? "")
    }

    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        dLog(webView.url?.scheme ?? "")
    }

    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        dLog(webView.url?.scheme ?? "")
    }

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        dLog(webView.url?.scheme ?? "")
    }

    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        dLog(webView.url?.scheme ?? "")
    }

    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        dLog(webView.url?.scheme ?? "")
        completionHandler(.performDefaultHandling,nil)
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        dLog(webView.url?.scheme ?? "")
    }

    func webView(_ webView: WKWebView, authenticationChallenge challenge: URLAuthenticationChallenge, shouldAllowDeprecatedTLS decisionHandler: @escaping (Bool) -> Void) {
        dLog(webView.url?.scheme ?? "")
        decisionHandler(true)
    }

}
