//
//  SwiftUILoadingView.swift
//  JuniorDeveloperAssignment
//
//  Created by Ekaterina Khudzhamkulova on 27.2.2021.
//

import SwiftUI

struct SwiftUILoadingView: UIViewRepresentable {
	@Binding var productsLoading: Bool

	func makeUIView(context: Context) -> UIView {
		LoadingView()
	}

	func updateUIView(_ uiView: UIView, context: Context) {
		uiView.isOpaque = productsLoading
	}
}
