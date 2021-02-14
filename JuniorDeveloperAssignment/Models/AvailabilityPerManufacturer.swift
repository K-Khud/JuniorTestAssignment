//
//  AvailabilityMatrix.swift
//  ReaktorJDAssignment
//
//  Created by Ekaterina Khudzhamkulova on 20.11.2020.
//

import Foundation

// MARK: - AvailabilityPerManufacturer
struct AvailabilityPerManufacturer: Codable {
	let code: Int?
	let response: [Response]?
}

// MARK: - Response
struct Response: Codable {
	let id, datapayload: String?

	enum CodingKeys: String, CodingKey {
		case id
		case datapayload = "DATAPAYLOAD"
	}
}
