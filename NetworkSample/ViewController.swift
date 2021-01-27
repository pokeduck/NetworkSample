//
// ViewController.swift
//
// Created by Ben for NetworkSample on 2021/1/26.
// Copyright © 2021 Alien. All rights reserved.
//

import SafariServices
import UIKit
import WebKit

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
    }

    @objc func go() {
        present(GitHubAuthViewController(), animated: true, completion: nil)
        // login(from: self)
        // fetchCookies()
    }

    func login(from vc: UIViewController) {
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
              let url = URL(string: path_)
        else {
            return
        }
//        UIApplication.shared.open(url, options: [:]) { _ in }

        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = false
        config.entersReaderIfAvailable = false
        let safariVC = SFSafariViewController(url: url, configuration: config)
        safariVC.delegate = self
        safariVC.dismissButtonStyle = .cancel
        safariVC.modalPresentationStyle = .automatic
        vc.present(safariVC, animated: true, completion: nil)
    }

    func fetchCookies() {
        let store = WKWebsiteDataStore.default()
        store.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                print("CookieName:\(record.displayName)")
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
