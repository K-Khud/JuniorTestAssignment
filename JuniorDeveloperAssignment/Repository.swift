//
//  Repository.swift
//  JuniorDeveloperAssignment
//
//  Created by Ekaterina Khudzhamkulova on 14.2.2021.
//

import Foundation
protocol IRepository: AnyObject {
	// MARK: - Methods called from CategoryViewController
	func fetchProducts(category: String)
	func fetchAvailability(for product: Product)
	// MARK: - Methods called from BadApiClient
	// Loads up the initial list with all products per category
	func didUpdateList(model: Products)
	// Loads up the availability for a particular product
	func didUpdateProduct(model: Product)
	// Error handling
	func didFailWithError(error: Error)
}
class Repository {
	private weak var parent: ICategoryViewController?
	private lazy var client = BadApiClient(parent: self)

	init(parent: CategoryViewController) {
		self.parent = parent
	}
}
extension Repository: IRepository {
	// MARK: - Methods called from CategoryViewController

	func fetchProducts(category: String) {
		client.fetchProducts(category: category)
	}

	func fetchAvailability(for product: Product) {
		client.fetchAvailability(for: product)
	}
	// MARK: - Methods called from BadApiClient
	func didUpdateList(model: Products) {
		parent?.didUpdateList(model: model)
	}

	func didUpdateProduct(model: Product) {
		parent?.didUpdateProduct(model: model)
	}

	func didFailWithError(error: Error) {
		parent?.didFailWithError(error: error)
	}
}
