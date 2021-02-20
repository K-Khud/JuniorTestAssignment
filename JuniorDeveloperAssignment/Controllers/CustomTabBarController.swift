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
		let glovesController 			= CategoryViewController(category: Constants.firstCategory)
		let facemasksViewController 	= CategoryViewController(category: Constants.secondCategory)
		let beaniesViewController 		= CategoryViewController(category: Constants.thirdCategory)
		let controllers 				= [glovesController, facemasksViewController, beaniesViewController]
			.map {UINavigationController(rootViewController: $0)}

		viewControllers = controllers

		glovesController.tabBarItem 		= UITabBarItem(
			title: Constants.firstCategory.capitalized,
			image: UIImage(systemName: Constants.tabFirstImageName), tag: 0)
		facemasksViewController.tabBarItem 	= UITabBarItem(
			title: Constants.secondCategory.capitalized,
			image: UIImage(systemName: Constants.tabSecondImageName), tag: 1)
		beaniesViewController.tabBarItem 	= UITabBarItem(
			title: Constants.thirdCategory.capitalized,
			image: UIImage(systemName: Constants.tabThirdImageName), tag: 2)
	}
}
