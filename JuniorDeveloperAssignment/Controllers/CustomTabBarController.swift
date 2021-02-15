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
		tabBar.tintColor 		= .systemPink
		tabBar.isTranslucent 	= true
		tabBar.barTintColor 	= .systemBackground
	}

	func setupControllers() {
		let glovesController 			= CategoryViewController(category: "gloves")
		let facemasksViewController 	= CategoryViewController(category: "facemasks")
		let beaniesViewController 		= CategoryViewController(category: "beanies")
		let controllers 				= [glovesController, facemasksViewController, beaniesViewController]
			.map {UINavigationController(rootViewController: $0)}

		viewControllers = controllers

		glovesController.tabBarItem 		= UITabBarItem(
			title: "Gloves",
			image: UIImage(systemName: "g.circle.fill"	), tag: 0)
		facemasksViewController.tabBarItem 	= UITabBarItem(
			title: "Facemasks",
			image: UIImage(systemName: "f.circle.fill"	), tag: 1)
		beaniesViewController.tabBarItem 	= UITabBarItem(
			title: "Beanies",
			image: UIImage(systemName: "b.circle.fill"
														), tag: 2)
	}
}
