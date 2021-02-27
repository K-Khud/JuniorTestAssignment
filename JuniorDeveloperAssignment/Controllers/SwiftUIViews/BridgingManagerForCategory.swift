//
//  BridgingManager.swift
//  JuniorDeveloperAssignment
//
//  Created by Ekaterina Khudzhamkulova on 24.2.2021.
//

import SwiftUI

class BridgingManagerForCategory: ObservableObject {
	let category			 					= Constants.firstCategory
	@Published var showingAlert 				= false
	@Published var productListIsLoading 		= true
	@Published var availabilityIsLoading	 	= false
	@Published var productsArray 				= Products()
	@Published var product						= Product(
													id: "123",
													type: TypeEnum.gloves,
													name: "default",
													color: [Color.blue],
													price: 10,
													manufacturer: Manufacturer.abiplos,
													availability: "default")
	lazy var repository 						= Repository(parent: self, category: category)

	init(category: String) {
		repository.fetchProducts(category: category)
	}
}

extension BridgingManagerForCategory: ICategoryViewController {
	// MARK: - Methods called from Repository
	func didUpdateList(model: Products) {
		DispatchQueue.main.async {
			self.productsArray 			= model
			self.productListIsLoading 	= false
		}
	}

	func didUpdateProduct(model: Product) {
		DispatchQueue.main.async {
			self.product = model
			self.availabilityIsLoading = false
		}
	}

	func didFailWithError(error: Error) {
		DispatchQueue.main.async {
			self.showingAlert = true
			self.availabilityIsLoading = false

		}
	}
	// MARK: - Methods called from Repository
	func tryFetchAvailability(for product: Product) {
		repository.fetchAvailability(for: product)
		self.availabilityIsLoading = true
	}

}
