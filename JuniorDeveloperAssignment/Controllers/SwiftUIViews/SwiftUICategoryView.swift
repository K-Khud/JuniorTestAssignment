//
//  SwiftUICategoryView.swift
//  JuniorDeveloperAssignment
//
//  Created by Ekaterina Khudzhamkulova on 23.2.2021.
//

import SwiftUI

struct SwiftUICategoryView: View {
	let category: String

	@StateObject var updater 			= BridgingManagerForCategory(category: Constants.firstCategory)
	@State private var searchText 		= ""

	var body: some View {
		if updater.productListIsLoading {
			SwiftUILoadingView(productsLoading: $updater.productListIsLoading)
		} else {
			VStack {
				SwiftUISearchBar(text: $searchText)
				List {
					ForEach(updater.productsArray.filter {
						self.searchText.isEmpty ? true : $0.name.contains(self.searchText.uppercased())
					}, id: \.self) { product in
						NavigationLink(destination: SwiftUIDetailsView().environmentObject(updater)
										.onAppear {
											updater.product = product
											updater.tryFetchAvailability(for: updater.product)
										}, label: {
											HStack(alignment: .center, content: {
												Circle()
													.foregroundColor(Constants.getColor(color: product.color[0]))
													.shadow(color: .black, radius: 1, x: 0, y: 0)
													.frame(width: 20, height: 20)
												VStack(alignment: .leading, spacing: .none, content: {
													Text(product.name)
													Text("\(Constants.detailsNames[4]) \(product.price)")
														.font(.system(size: 12))
													Text("\(Constants.detailsNames[5]) \(product.manufacturer.rawValue)")
														.font(.system(size: 12))
												})
												Spacer()
											})
										})
					}
				}
			}
			.alert(isPresented: $updater.showingAlert) {
				Alert(title: Text(Constants.alertTitle),
					  message: Text(Constants.alertMessage),
					  primaryButton: .default(Text(Constants.alertTryTitle), action: {
						updater.tryFetchAvailability(for: updater.product)
					  }),
					  secondaryButton: .cancel(Text(Constants.alertCancelTitle), action: {
						updater.product.availability = Constants.noAvailability
					  }))
			}
		}
	}
}

struct SwiftUICategoryView_Previews: PreviewProvider {
    static var previews: some View {
		SwiftUICategoryView(category: "Some category")
    }
}
