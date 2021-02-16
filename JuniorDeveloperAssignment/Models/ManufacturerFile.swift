//
//  ManufacturerFile.swift
//  JuniorDeveloperAssignment
//
//  Created by Ekaterina Khudzhamkulova on 15.2.2021.
//

import Foundation

struct ManufacturerFile: Codable {
	let name: String
	let payload: [PayloadFile]
}

struct PayloadFile: Codable {
	let id: String
	let payload: String
}
