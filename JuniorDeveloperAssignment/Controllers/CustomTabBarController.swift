//
//  CustomTabBarController.swift
//  ReaktorJDAssignment
//
//  Created by Ekaterina Khudzhamkulova on 28.11.2020.
//
import SwiftUI
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
		let glovesRootView 				= SwiftUICategoryView(category: Constants.firstCategory)
		let swiftUIGloves 				= UIHostingController(rootView: glovesRootView)

		let facemasksViewController 	= CategoryViewController(category: Constants.secondCategory)
		let beaniesViewController 		= CategoryViewController(category: Constants.thirdCategory)
		let controllers 				= [swiftUIGloves, facemasksViewController, beaniesViewController]
			.map {UINavigationController(rootViewController: $0)}

		viewControllers = controllers

		swiftUIGloves.tabBarItem 		= UITabBarItem(
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
