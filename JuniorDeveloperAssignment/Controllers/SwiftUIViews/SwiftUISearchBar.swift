//
//  SwiftUISearchBar.swift
//  JuniorDeveloperAssignment
//
//  Created by Ekaterina Khudzhamkulova on 23.2.2021.
//

import SwiftUI

struct SwiftUISearchBar: UIViewRepresentable {
	typealias UIViewType = UISearchBar

	@Binding var text: String

	class Coordinator: NSObject, UISearchBarDelegate {

		@Binding var text: String

		init(text: Binding<String>) {
			_text = text
		}

		func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
			text = searchText
		}
	}

	func makeCoordinator() -> SwiftUISearchBar.Coordinator {
		return Coordinator(text: $text)
	}

	func makeUIView(context: UIViewRepresentableContext<SwiftUISearchBar>) -> UISearchBar {
		let searchBar 						= UISearchBar(frame: .zero)
		searchBar.delegate 					= context.coordinator
		searchBar.searchBarStyle 			= .minimal
		searchBar.placeholder 				= Constants.searchPlaceHolder
		searchBar.autocapitalizationType 	= .none
		return searchBar
	}

	func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SwiftUISearchBar>) {
		uiView.text = text
	}
}

struct SwiftUISearchBar_Previews: PreviewProvider {
	static var previews: some View {
		SwiftUISearchBar(text: Binding.constant("Search"))
	}
}
