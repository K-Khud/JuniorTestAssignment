//
//  Cache.swift
//  JuniorDeveloperAssignment
//
//  Created by Ekaterina Khudzhamkulova on 15.2.2021.
//

import UIKit
import CoreData

protocol IProductsCache {
	func updateCache(with products: [Product], category: String)
	func getProductsFromCache(for type: String) -> [Product]?
}

class ProductsCache {
	private weak var parent: IRepository?
	private var productsCached 				= [ProductCache]()
	private let context 					= (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
	init(parent: IRepository) {
		self.parent = parent
	}

	// MARK: - Load & Save Methods
	private func loadCachedProducts(
		with request: NSFetchRequest<ProductCache> = ProductCache.fetchRequest(),
		predicate: NSPredicate? = nil) -> [Product]? {
		guard let context = context else { return nil}

		productsCached.removeAll()

		if let predicate = predicate {
			request.predicate 	= predicate
		}
		do {
			productsCached 		= try context.fetch(request)
		} catch {
			print("Error fetching cachedProducts, \(error)")
		}

		return !productsCached.isEmpty ? parseFromCache() : nil
	}

	private func save() {
		guard let context = context else { return }

		do {
			try context.save()

		} catch {
			print("Error saving cachedProducts, \(error)")
		}
	}
	private func cacheTimeValidation(for type: String) -> Bool {
		guard let productTimestamp = productsCached
				.filter({$0.type == type})
				.first?.timestamp else {return false}
		return (NSDate().timeIntervalSince1970 - productTimestamp) < Constants.cacheTimeSeconds
	}
	private func clearCache(for type: String) {
		productsCached.forEach { (productCached) in
			if productCached.type == type {
				context?.delete(productCached)
			}
		}
		productsCached = productsCached.filter({$0.type != type})
	}

	private func parseFromCache() -> [Product] {
		var products = [Product]()
			self.productsCached.forEach { (productCached) in
				let newProduct = Product(
					id: productCached.id ?? "",
					type: TypeEnum(rawValue: productCached.type ?? Constants.firstCategory) ?? .gloves,
					name: productCached.name ?? "",
					color: [Color(rawValue: productCached.color ?? Color.black.rawValue) ?? .black],
					price: Int(productCached.price),
					manufacturer: Manufacturer(rawValue: productCached.manufacturer ?? Manufacturer.abiplos.rawValue) ?? .abiplos,
					availability: productCached.availability)

				products.append(newProduct)
			}
		return products
	}
}

extension ProductsCache: IProductsCache {
	func updateCache(with products: [Product], category: String) {
		guard let context 		= context else { return }

			products.forEach { (product) in
				let newProductCached 			= ProductCache(context: context)

				newProductCached.id 			= product.id
				newProductCached.color 			= product.color.first?.rawValue ?? ""
				newProductCached.name 			= product.name
				newProductCached.price 			= Int64(product.price)
				newProductCached.type			= product.type.rawValue
				newProductCached.manufacturer 	= product.manufacturer.rawValue
				newProductCached.timestamp		= NSDate().timeIntervalSince1970
				self.productsCached.append(newProductCached)
			}
			self.save()
	}

	func getProductsFromCache(for type: String) -> [Product]? {
		guard let products = loadCachedProducts() else { return nil }
		guard cacheTimeValidation(for: type) else {
			clearCache(for: type)
			return nil
		}

		let outputArray = products.filter { $0.type == TypeEnum(rawValue: type) }

		return outputArray.count > 0 ? outputArray : nil
	}
}
