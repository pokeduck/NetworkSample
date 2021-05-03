//
// ViewController.swift
//
// Created by Ben for NetworkSample on 2021/1/26.
// Copyright © 2021 Alien. All rights reserved.
//

import AuthenticationServices
import FLEX
import Moya
import NSObject_Rx
import RxSwift
import SafariServices
import SwifterSwift
import UIKit
import WebKit

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    let githubLoginManager = GitHubLoginManager()
    let twitterLoginManager = TwitterLoginManager()
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
        SymmetricEncryption().test()
//        present(PhotosVC(), animated: true, completion: nil)
        //githubLoginManager.login()
        //twitterLoginManager.login()
//        API.request(Twitter.VerifyCredentials()).subscribe { (model) in
//            dLog(model)
//        } onError: { (error) in
//            dLog(error.localizedDescription)
//        }.disposed(by: rx.disposeBag)

        //FLEXManager.shared.showExplorer()
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
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first!
        return window
    }
}
