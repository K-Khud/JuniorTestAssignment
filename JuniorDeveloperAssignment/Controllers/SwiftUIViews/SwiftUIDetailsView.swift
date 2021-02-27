//
//  SwiftUIDetailsView.swift
//  JuniorDeveloperAssignment
//
//  Created by Ekaterina Khudzhamkulova on 23.2.2021.
//

import SwiftUI

struct SwiftUIDetailsView: View {
	@EnvironmentObject var updater: BridgingManagerForCategory

	var body: some View {
		VStack(alignment: .leading, spacing: 6) {
			Text(Constants.detailsTitle)
				.bold()
				.padding()
				.font(.system(size: 32))
				.foregroundColor(.pink)
			List {
				Text("\(Constants.detailsNames[0]) \(updater.product.type.rawValue)")
				Text("\(Constants.detailsNames[1]) \(updater.product.name)")
				Text("\(Constants.detailsNames[2]) \(updater.product.color[0].rawValue)")
				Text("\(Constants.detailsNames[3]) \(updater.product.id)")
				Text("\(Constants.detailsNames[4]) \(updater.product.price)")
				Text("\(Constants.detailsNames[5]) \(updater.product.manufacturer.rawValue)")
				HStack {
				Text("\(Constants.detailsNames[6]) \(updater.product.availability ?? "")")
					if updater.availabilityIsLoading {
						ProgressView()
					}
				}
			}
		}
	}
}

struct SwiftUIDetailsView_Previews: PreviewProvider {
	static var product = Product(id: "123",
						  type: TypeEnum.gloves,
						  name: "default",
						  color: [Color.blue],
						  price: 10,
						  manufacturer: Manufacturer.abiplos,
						  availability: "default")
    static var previews: some View {
		SwiftUIDetailsView()
    }
}
