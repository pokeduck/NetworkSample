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

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.setTitle("Go", for: .normal)
        btn.addTarget(self, action: #selector(go), for: .touchUpInside)
        btn.frame = CGRect(x: 30, y: 30, width: 100, height: 100)
        view.addSubview(btn)

        let ringtonPath = Bundle.main.path(forResource: "hoho", ofType: "wav")!
        let bundleRingUrl = URL(fileURLWithPath: ringtonPath)
        let path = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        let url = path[0].appendingPathComponent("Sounds", isDirectory: true)
        let targetURL = url.appendingPathComponent("hoho.wav")
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        try? FileManager.default.copyItem(at: bundleRingUrl, to: targetURL)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @objc func go() {
//        FLEXManager.shared.showExplorer()

//        present(GitHubAuthViewController(), animated: true, completion: nil)
        //fetchCookies()

         login(from: self)
    }

    func login(from vc: UIViewController) {
        let authorize = GitHub.Authorize()

        ASWebAuthenticationSession.present(url: authorize.fullURL!, from: self) { (url, error) in
            dLog(url)
        }
        
        
//        UIApplication.shared.open(url, options: [:]) { _ in }
        let auth = ASWebAuthenticationSession(url: authorize.fullURL!, callbackURLScheme: nil) { (url, error) in
            dLog(url)
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
