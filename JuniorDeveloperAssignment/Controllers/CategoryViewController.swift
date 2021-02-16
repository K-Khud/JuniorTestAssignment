//
//  ShirtsViewController.swift
//  ReaktorJDAssignment
//
//  Created by Ekaterina Khudzhamkulova on 28.11.2020.
//

import UIKit
protocol ICategoryViewController: AnyObject {
	// Loads up the initial list with all products per category
	func didUpdateList(model: Products)
	// Loads up the availability for a particular product
	func didUpdateProduct(model: Product)
	// Error handling
	func didFailWithError(error: Error)
}

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private let category: String
	private lazy var repository = Repository(parent: self, category: category)
	private var detailsViewController: DetailsViewController?
	private var tableView 		= UITableView()
	private var productsArray 	= Products()
	private var filteredData 	= Products()
	private var listIsFiltered 	= false
	private var loadingView 	= LoadingView(frame: .zero)
	private var itemColorImage 	= UIImage(systemName: "circle.fill")?.withTintColor(.magenta)

	private var searchBar: UISearchBar = {
		let bar 			= UISearchBar()
		bar.placeholder 	= "Search"
		bar.backgroundColor = .systemBackground
		bar.searchBarStyle 	= .minimal
		return bar
	}()

	init(category: String) {
		self.category = category
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
//		client.delegate 									= self
		tableView.delegate 									= self
		tableView.dataSource 								= self
		searchBar.searchTextField.delegate 					= self
		searchBar.delegate 									= self
		navigationController?.navigationBar.backgroundColor = .systemBackground
		registerCells()
		configureSearchBar()
		configureTableView()
		repository.fetchProducts(category: category)
		setupLoadingView()
	}

	private func configureSearchBar() {
		self.view.addSubview(searchBar)
		searchBar.translatesAutoresizingMaskIntoConstraints 											= false
		searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive 			= true
		searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive 	= true
		searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive 	= true
	}

	private func configureTableView() {
		self.view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints 											= false
		tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive 						= true
		tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive 		= true
		tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive 	= true
		tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive 	= true
	}

	private func setupLoadingView() {
		view.addSubview(loadingView)
		loadingView.backgroundColor = .systemBackground
		loadingView.translatesAutoresizingMaskIntoConstraints 												= false
		loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive 				= true
		loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive 		= true
		loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive 		= true
		loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive 	= true
	}

	private func registerCells() {
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "shirtsCell")
	}

	// MARK: - TableViewDataSource methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// If product list is filtered as per user's search, the table shows the search results
		let rowsCount = listIsFiltered ? filteredData.count : productsArray.count
		return rowsCount
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let arrayForDisplay = listIsFiltered ? filteredData : productsArray
		animateLoading()
		let cell 					= UITableViewCell(style: .subtitle, reuseIdentifier: "shirtsCell")
		let color 					= arrayForDisplay[indexPath.row].color[0]
		let name 					= arrayForDisplay[indexPath.row].name
		let manufacturer 			= arrayForDisplay[indexPath.row].manufacturer.rawValue
		let price 					= String(arrayForDisplay[indexPath.row].price)
		let detailsString 			= "price: \(price), manufacturer: \(manufacturer)"
		cell.imageView?.image 		= getImageColored(color: color)
		cell.textLabel?.text 		= name
		cell.accessoryType 			= .disclosureIndicator
		cell.detailTextLabel?.text 	= detailsString
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let arrayForDisplay = listIsFiltered ? filteredData : productsArray
		repository.fetchAvailability(for: arrayForDisplay[indexPath.row])
		detailsViewController = DetailsViewController(product: arrayForDisplay[indexPath.row])
		if let detailsViewController = detailsViewController {
			self.navigationController?.pushViewController(detailsViewController,
														  animated: true)
		}
	}

	private func getImageColored(color: Color) -> UIImage? {
		if let image = itemColorImage {
			switch color {
			case .black: return image.withTintColor(.black, renderingMode: .alwaysOriginal)
			case .blue: return image.withTintColor(.blue, renderingMode: .alwaysOriginal)
			case .green: return image.withTintColor(.green, renderingMode: .alwaysOriginal)
			case .grey: return image.withTintColor(.gray, renderingMode: .alwaysOriginal)
			case .purple: return image.withTintColor(.purple, renderingMode: .alwaysOriginal)
			case .red: return image.withTintColor(.red, renderingMode: .alwaysOriginal)
			case .white: return image.withTintColor(.white, renderingMode: .alwaysOriginal)
			case .yellow: return image.withTintColor(.yellow, renderingMode: .alwaysOriginal)
			}
		}
		return itemColorImage
	}

	// MARK: - Loading Animation
	private func animateLoading() { // Loading view fading animation
		let animation 			= CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
		animation.duration 		= 2
		animation.autoreverses 	= false
		if productsArray.count == 0 {
			animation.fromValue = 0
			animation.toValue 	= 1
		}
		loadingView.layer.add(animation, forKey: "loadingAnimation")
		loadingView.layer.opacity = 0
	}
}
// MARK: - BadApiClientDelegate methods
extension CategoryViewController: ICategoryViewController {

	func didUpdateList(model: Products) {
		DispatchQueue.main.async {
			self.productsArray = model
			self.tableView.reloadData()
		}
	}

	func didUpdateProduct(model: Product) {
		DispatchQueue.main.async {
			self.detailsViewController?.updateData(with: model)
		}
	}

	func didFailWithError(error: Error) {
		print(error)
		// TODO: show the try again alert!
	}
}
// MARK: - UITextFieldDelegate methods
extension CategoryViewController: UISearchTextFieldDelegate, UISearchBarDelegate {
	func textFieldDidChangeSelection(_ textField: UITextField) {
		searchBar.setShowsCancelButton(true, animated: true)
		filteredData = productsArray
		if let query = textField.text?.uppercased() {
			filteredData = productsArray
				.filter({$0.id.uppercased().contains(query)
							|| $0.name.contains(query)
							|| $0.name.contains(query)
							|| $0.manufacturer.rawValue.uppercased().contains(query)})
			listIsFiltered = true
		} else {
			listIsFiltered = false
		}
		tableView.reloadData()
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(false, animated: true)
		searchBar.resignFirstResponder()
		listIsFiltered = false
		searchBar.text = ""
		tableView.reloadData()
	}
}
