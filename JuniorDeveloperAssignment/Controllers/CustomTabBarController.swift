//
//  CustomTabBarController.swift
//  ReaktorJDAssignment
//
//  Created by Ekaterina Khudzhamkulova on 28.11.2020.
//

import UIKit

class CustomTabBarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()
		setupControllers()
		tabBar.tintColor = .systemPink
		tabBar.isTranslucent = true
		tabBar.barTintColor = .systemBackground
	}

	func setupControllers() {
		let jacketsController 			= CategoryViewController(category: "gloves")
		let shirtsViewController 		= CategoryViewController(category: "facemasks")
		let accessoriesViewController 	= CategoryViewController(category: "beanies")
		let controllers = [jacketsController, shirtsViewController, accessoriesViewController]
			.map {UINavigationController(rootViewController: $0)}

		viewControllers = controllers

		jacketsController.tabBarItem = UITabBarItem(title: "Jackets", image: UIImage(systemName: "j.circle.fill"), tag: 0)
		shirtsViewController.tabBarItem = UITabBarItem(title: "Shirts", image: UIImage(systemName: "s.circle.fill"), tag: 1)
		accessoriesViewController.tabBarItem = UITabBarItem(
			title: "Accessories",
			image: UIImage(systemName: "a.circle.fill"
															), tag: 2)
	}
}
