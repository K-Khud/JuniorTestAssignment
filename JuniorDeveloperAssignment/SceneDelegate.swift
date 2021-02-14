//
//  SceneDelegate.swift
//  JuniorDeveloperAssignment
//
//  Created by Ekaterina Khudzhamkulova on 29.11.2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard (scene as? UIWindowScene) != nil else { return }
		guard let windowScene = (scene as? UIWindowScene) else { return }

		let tabBarViewController = CustomTabBarController()

		window = UIWindow(frame: windowScene.coordinateSpace.bounds)
		window?.windowScene = windowScene
		window?.rootViewController = tabBarViewController
		window?.makeKeyAndVisible()

	}

	func sceneDidDisconnect(_ scene: UIScene) {
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
	}

	func sceneWillResignActive(_ scene: UIScene) {
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
	}
}
