//
//  AvailabilityCache.swift
//  JuniorDeveloperAssignment
//
//  Created by Ekaterina Khudzhamkulova on 15.2.2021.
//

import UIKit
import CoreData

protocol IAvailabilityCache {
	func getProductAvailability(for productID: String) -> String?
	func updateCache(for manufacturer: ManufacturerFile)
}

class AvailabilityCache {
	private weak var parent: IRepository?
//	private var availabilityCached 	= [ManufacturerCache]()
	private var contentsCached		= [Content]()
	private let context 			= (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

	init(parent: IRepository) {
		self.parent = parent
	}
	// MARK: - Load & Save Methods
//	private func loadCachedAvailability(
//		with request: NSFetchRequest<ManufacturerCache> = ManufacturerCache.fetchRequest(),
//		predicate: NSPredicate? = nil) {
//
//		guard let context = context else { return }
//
//		if let predicate = predicate {
//			request.predicate 	= predicate
//		}
//		do {
//			availabilityCached 		= try context.fetch(request)
//		} catch {
//			print("Error fetching availability, \(error)")
//		}
//		print(#function)
//		print("availabilityCached.count = \(availabilityCached.count)")
//
////		return !availabilityCached.isEmpty ? availabilityCached : nil
//	}

	private func loadCachedContents(
		with request: NSFetchRequest<Content> = Content.fetchRequest(),
		predicate: NSPredicate? = nil) {

		guard let context = context else { return }

		if let predicate = predicate {
			request.predicate 	= predicate
		}
		do {
			contentsCached 		= try context.fetch(request)
		} catch {
			print("Error fetching contents, \(error)")
		}
		print(#function)
		print("contentsCached.count = \(contentsCached.count)")

//		return !contentsCached.isEmpty ? contentsCached : nil
	}

	private func save() {
		guard let context = context else { return }

		do {
			try context.save()
			print(#function)

		} catch {
			print("Error saving cachedAvailability, \(error)")
		}
	}

//	private func clearCache(manufacturerName: String) {
//		guard let context = context else { return }
//
//			self.availabilityCached.forEach { (manufacturer) in
//				if manufacturer.name == manufacturerName {
//					context.delete(manufacturer)
//				}
//			}
//		print(#function)
//		availabilityCached = availabilityCached.filter {$0.name != manufacturerName}
//		print("availabilityCached.count = \(availabilityCached.count)")
//	}

}

extension AvailabilityCache: IAvailabilityCache {
	func updateCache(for manufacturer: ManufacturerFile) {
		guard let context 		= context else { return }

		manufacturer.payload.forEach { (payload) in
			let newPayloadCached 				= Content(context: context)
			newPayloadCached.id?			 	= payload.id.uppercased()
			newPayloadCached.payload 			= payload.payload
			contentsCached.append(newPayloadCached)
			}

			self.save()
	}

	func getProductAvailability(for productID: String) -> String? {
		print(#function)
		print("productID = \(productID)")

		contentsCached.removeAll()

		loadCachedContents()

		let outputAvailability = contentsCached.filter {$0.id == productID.uppercased()}

		print("outputAvailability.first?.payload = \(outputAvailability.first?.payload)")

//		print("outputArray.count = \(outputArray.count)")
		return outputAvailability.first?.payload

	}
}
