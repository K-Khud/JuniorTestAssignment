//
//  BadApiClient.swift
//  ReaktorJDAssignment
//
//  Created by Ekaterina Khudzhamkulova on 20.11.2020.
//

import Foundation

protocol BadApiClientDelegate: AnyObject {
	// Loads up the initial list with all products per category
	func didUpdateList(_ badApiClient: BadApiClient, model: Products)
	// Loads up the availability for a particular product
	func didUpdateProduct(_ badApiClient: BadApiClient, model: Product)
	// Error handling
	func didFailWithError(error: Error)
}

public class BadApiClient {
	weak var delegate: BadApiClientDelegate?

	private let apiUrl = "https://bad-api-assignment.reaktor.com/v2/"
	private var currentProduct: Product?
	// The following method gets called upon initial loading of a chosen viewController
	func fetchProducts(category: String) {
		let urlString = "\(apiUrl)products/\(category)"
		// Performing request for a chosen category
		performRequest(with: urlString) { (result) in
			_ = result.map { (data) in
				if data.isEmpty {
					print("Data is empty")
				} else {
					// Parsing data that was received with the request and sending it to the delegate a.k.a CategoryViewController
					if let data = self.parseJsonToProducts(data) {
						self.delegate?.didUpdateList(self, model: data)
					}
				}
			}
		}
	}

	// The following method gets called when a user proceeds to check product details
	func fetchAvailability(for product: Product) {
		let urlString = "\(apiUrl)availability/\(product.manufacturer.rawValue)"
		// Performing request for a chosen manufacturer
		performRequest(with: urlString) { (result) in
			_ = result.map { (data) in
				if data.isEmpty {
					print("Data is empty")
				} else {
					if let safeData = self.parseJsonToAvailabilityList(data) {
						safeData.forEach { (availability) in

							if availability.id == product.id.uppercased() {
								// Filtering the availability string to display the meaninful part
								let filteredAvailability = availability.datapayload?
									.replacingOccurrences(of: "<AVAILABILITY>\n  <CODE>200</CODE>\n  <INSTOCKVALUE>", with: "")
									.replacingOccurrences(of: "</INSTOCKVALUE>\n</AVAILABILITY>", with: "")
								let updatedProduct = Product(id: product.id,
															 type: product.type,
															 name: product.name,
															 color: product.color,
															 price: product.price,
															 manufacturer: product.manufacturer,
															 availability: filteredAvailability)
								// Parsing data that was received with the request and sending it to the delegate a.k.a CategoryViewController
								self.delegate?.didUpdateProduct(self, model: updatedProduct)
							}
						}
					}
				}
			}
		}
	}
// MARK: - Private Methods
	private func performRequest(with urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
		if let url = URL(string: urlString) {
			let session = URLSession(configuration: .default)
			let request = NSMutableURLRequest(url: url,
											  cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
											  timeoutInterval: 60.0)
			request.httpMethod = "GET"
			// Headers to force the response error:
//			let headers = ["x-force-error-mode": "all"]
//			request.allHTTPHeaderFields = headers
			let dataTask = session.dataTask(with: request as URLRequest,
											completionHandler: { (data, _, error) -> Void in
												if let error = error {
													self.delegate?.didFailWithError(error: error)
													completion(.failure(error))
												} else {
													if let safeData = data {
														completion(.success(safeData))
													}
												}
											})
			dataTask.resume()
		}
	}

	private func parseJsonToProducts(_ data: Data) -> Products? {
		var productsArray = Products()
		let decoder = JSONDecoder()
		do {
			let decodedData = try decoder.decode(Products.self, from: data)
			decodedData.forEach { (product) in
				let newProduct = Product(id: product.id,
									   type: product.type,
									   name: product.name,
									   color: product.color,
									   price: product.price,
									   manufacturer: product.manufacturer)
				productsArray.append(newProduct)
			}
			return productsArray
		} catch {
			delegate?.didFailWithError(error: error)
			return nil
		}
	}

	private func parseJsonToAvailabilityList(_ data: Data) -> [Response]? {
		var availabilityArray = [Response]()
		let decoder = JSONDecoder()
		do {
			let decodedData = try decoder.decode(AvailabilityPerManufacturer.self, from: data)
			if let response = decodedData.response {
				response.forEach { (item) in
					let newItem = Response(id: item.id, datapayload: item.datapayload)
					availabilityArray.append(newItem)
				}
			}
			return availabilityArray
		} catch {
			delegate?.didFailWithError(error: error)
			return nil
		}
	}
}
