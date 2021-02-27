//
//  Constants.swift
//  JuniorDeveloperAssignment
//
//  Created by Ekaterina Khudzhamkulova on 20.2.2021.
//

import UIKit
import SwiftUI
struct Constants {
	static let baseURL 					= "https://bad-api-assignment.reaktor.com/v2/"
	static let cacheTimeSeconds: Double	= 5 * 60
	static let firstCategory			= "gloves"
	static let secondCategory			= "facemasks"
	static let thirdCategory			= "beanies"

	static let categoryCellId			= "cellId"
	static let detailsCellId			= "detailsCell"

	static let searchPlaceHolder		= "Start typing product name"
	static let colorImageName			= "circle.fill"
	static let tabFirstImageName		= "g.circle.fill"
	static let tabSecondImageName		= "f.circle.fill"
	static let tabThirdImageName		= "b.circle.fill"

	static let detailsTitle				= "Product Info"
	static let detailsNames				= ["Type: ", "Name: ", "Color: ", "ID: ", "Price: ", "Manufacturer: ", "Availability: "]

	static let alertTitle				= "Error"
	static let alertMessage				= "Failed to access availability information."
	static let alertTryTitle			= "Try again"
	static let alertCancelTitle			= "Cancel"

	static let noAvailability			= "no info"

	static func getImageColored(color: Color) -> UIImage? {
		let image = UIImage(systemName: Constants.colorImageName)
		if let itemColorImage = image {
		switch color {
		case .black: return itemColorImage.withTintColor(.black, renderingMode: .alwaysOriginal)
		case .blue: return itemColorImage.withTintColor(.blue, renderingMode: .alwaysOriginal)
		case .green: return itemColorImage.withTintColor(.green, renderingMode: .alwaysOriginal)
		case .grey: return itemColorImage.withTintColor(.gray, renderingMode: .alwaysOriginal)
		case .purple: return itemColorImage.withTintColor(.purple, renderingMode: .alwaysOriginal)
		case .red: return itemColorImage.withTintColor(.red, renderingMode: .alwaysOriginal)
		case .white: return itemColorImage.withTintColor(.white, renderingMode: .alwaysOriginal)
		case .yellow: return itemColorImage.withTintColor(.yellow, renderingMode: .alwaysOriginal)
		}
		}
		return image
	}
	static func getColor(color: Color) -> SwiftUI.Color? {
		var uicolor: UIColor
		switch color {
		case .black: uicolor = .black
		case .blue: uicolor = .blue
		case .green: uicolor = .green
		case .grey: uicolor = .gray
		case .purple: uicolor = .purple
		case .red: uicolor = .red
		case .white: uicolor = .white
		case .yellow: uicolor = .yellow
		}
		return SwiftUI.Color(uicolor)
	}
}
