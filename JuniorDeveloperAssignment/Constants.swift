//
//  Constants.swift
//  JuniorDeveloperAssignment
//
//  Created by Ekaterina Khudzhamkulova on 20.2.2021.
//

import Foundation

struct Constants {
	static let baseURL 					= "https://bad-api-assignment.reaktor.com/v2/"
	static let cacheTimeSeconds: Double	= 5 * 60
	static let firstCategory			= "gloves"
	static let secondCategory			= "facemasks"
	static let thirdCategory			= "beanies"

	static let categoryCellId			= "cellId"
	static let detailsCellId			= "detailsCell"

	static let searchPlaceHolder		= "Search"
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
}
