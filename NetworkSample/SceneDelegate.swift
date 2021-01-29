//
// SceneDelegate.swift
//
// Created by Ben for NetworkSample on 2021/1/26.
// Copyright © 2021 Alien. All rights reserved.
//

import Moya
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // po URLContexts.first?.options.sourceApplication
        // UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController?.presentedViewController
        guard let path = URLContexts.first?.url.absoluteString,
              let queryItems = URLComponents(string: path)?.queryItems
        else { return }
        var code = ""
        var state = ""
        queryItems.forEach { item in
            switch item.name {
            case "code":
                code = item.value ?? ""
            case "state":
                state = item.value ?? ""
            default:
                break
            }
        }
        let access = GitHub.AccessToken(code: code, state: state)
        print(access.headers)
        MoyaProvider<GitHub.AccessToken>().request(access) { result in
            switch result {
            case let .success(resp):
                let responseJSON = String(data: resp.data, encoding: .utf8)
                print(responseJSON)
            case let .failure(error):
                print(error.localizedDescription)
            }
            print(result)
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (result, error) in
            
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
extension SceneDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        funcLog()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let resp = response.notification.request.content.userInfo
        dLog(resp)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        funcLog()
        completionHandler([.alert,.badge,.sound])
    }
}
