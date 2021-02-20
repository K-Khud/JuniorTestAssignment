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
	private var contentsCached		= [Content]()
	private let context 			= (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

	init(parent: IRepository) {
		self.parent = parent
	}

	// MARK: - Load & Save Methods
	private func loadCachedContents(
		with request: NSFetchRequest<Content> = Content.fetchRequest(),
		predicate: NSPredicate? = nil) {
		guard let context = context else { return }

		contentsCached.removeAll()

		if let predicate = predicate {
			request.predicate 	= predicate
		}
		do {
			contentsCached 		= try context.fetch(request)
		} catch {
			print("Error fetching contents, \(error)")
		}
	}

	private func save() {
		guard let context = context else { return }

		do {
			try context.save()
		} catch {
			print("Error saving cachedAvailability, \(error)")
		}
	}
	private func cacheTimeValidation(for record: Content, currentTimestamp: Double) -> Bool {
		return (currentTimestamp - record.timestamp) < Constants.cacheTimeSeconds
	}
	private func clearCache(currentTimestamp: Double) {
		contentsCached.forEach { (record) in
			if currentTimestamp - record.timestamp >= Constants.cacheTimeSeconds {
				context?.delete(record)
			}
		}
		contentsCached = contentsCached.filter({currentTimestamp - $0.timestamp < Constants.cacheTimeSeconds})
	}

}

extension AvailabilityCache: IAvailabilityCache {
	func updateCache(for manufacturer: ManufacturerFile) {
		guard let context 		= context else { return }

		manufacturer.payload.forEach { (payload) in
			let newPayloadCached 				= Content(context: context)
			newPayloadCached.id?			 	= payload.id.uppercased()
			newPayloadCached.payload 			= payload.payload
			newPayloadCached.timestamp			= NSDate().timeIntervalSince1970
			contentsCached.append(newPayloadCached)
			}

			self.save()
	}

	func getProductAvailability(for productID: String) -> String? {
		loadCachedContents()
		let currentTimeStamp = NSDate().timeIntervalSince1970
		guard let recordContent = contentsCached
				.filter({$0.id == productID.uppercased()})
				.first else { return nil }

		guard cacheTimeValidation(for: recordContent, currentTimestamp: currentTimeStamp) else {
			clearCache(currentTimestamp: currentTimeStamp)
			return nil
		}
		return recordContent.payload
	}
}
