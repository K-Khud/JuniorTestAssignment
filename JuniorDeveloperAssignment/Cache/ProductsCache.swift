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
	private var productsCached 	= [ProductCache]()
	private let context 		= (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

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
//	private func clearCache(category: String) {
//		guard let context = context else { return }
//
//			self.productsCached.forEach { (cachedProduct) in
//				if cachedProduct.type == category {
//					context.delete(cachedProduct)
//				}
//			}
//
//		productsCached = productsCached.filter{$0.type != category}
//	}

	private func parseFromCache() -> [Product] {
		var products = [Product]()
			self.productsCached.forEach { (productCached) in
				let newProduct = Product(
					id: productCached.id ?? "",
					type: TypeEnum(rawValue: productCached.type ?? "gloves") ?? .gloves,
					name: productCached.name ?? "",
					color: [Color(rawValue: productCached.color ?? "black") ?? .black],
					price: Int(productCached.price),
					manufacturer: Manufacturer(rawValue: productCached.manufacturer ?? "abiplos") ?? .abiplos,
					availability: productCached.availability)

				products.append(newProduct)
			}
		return products
	}
}

extension ProductsCache: IProductsCache {
	func updateCache(with products: [Product], category: String) {
		guard let context 		= context else { return }

//		let productsPerCategory = productsCached.filter { $0.type == category }
//		if productsPerCategory.count > 0 {
//			clearCache(category: category)
//		}

			products.forEach { (product) in
				let newProductCached 			= ProductCache(context: context)

				newProductCached.id 			= product.id
				newProductCached.color 			= product.color.first?.rawValue ?? ""
				newProductCached.name 			= product.name
				newProductCached.price 			= Int64(product.price)
				newProductCached.type			= product.type.rawValue
				newProductCached.manufacturer 	= product.manufacturer.rawValue
				self.productsCached.append(newProductCached)
			}
			self.save()
	}

	func getProductsFromCache(for type: String) -> [Product]? {
		guard let products = loadCachedProducts() else {return nil}

		let outputArray = products.filter { $0.type == TypeEnum(rawValue: type) }

		return outputArray.count > 0 ? outputArray : nil
	}
}
