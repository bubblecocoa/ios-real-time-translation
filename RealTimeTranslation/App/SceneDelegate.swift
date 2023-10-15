//
//  SceneDelegate.swift
//  RealTimeTranslation
//
//  Created by BMO on 2023/10/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let viewController = TranslationViewController()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
