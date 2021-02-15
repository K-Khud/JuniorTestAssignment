//
//  JacketModel.swift
//  ReaktorJDAssignment
//
//  Created by Ekaterina Khudzhamkulova on 20.11.2020.
//

import Foundation

struct Product: Codable {
	let id: String
	let type: TypeEnum
	let name: String
	let color: [Color]
	let price: Int
	let manufacturer: Manufacturer
	var availability: String?
}

enum Color: String, Codable {
	case black
	case blue
	case green
	case grey
	case purple
	case red
	case white
	case yellow
}

enum Manufacturer: String, Codable {
	case abiplos
	case ippal
	case juuran
	case laion
	case niksleh
	case umpante
}

enum TypeEnum: String, Codable {
	case gloves
	case facemasks
	case beanies
}

typealias Products = [Product]
