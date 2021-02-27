//
//  ShirtsViewController.swift
//  ReaktorJDAssignment
//
//  Created by Ekaterina Khudzhamkulova on 28.11.2020.
//

import UIKit
protocol ICategoryViewController {
	// MARK: - Methods called from Repository
	// Loads up the initial list with all products per category
	func didUpdateList(model: Products)
	// Loads up the availability for a particular product
	func didUpdateProduct(model: Product)
	// Error handling
	func didFailWithError(error: Error)
	// MARK: - Methods called from Repository
	func tryFetchAvailability(for product: Product)
}

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private let category: String
	private var detailsViewController: DetailsViewController?
	private lazy var repository = Repository(parent: self, category: category)
	private var tableView 		= UITableView()
	private var productsArray 	= Products()
	private var filteredData 	= Products()
	private var listIsFiltered 	= false
	private var loadingView 	= LoadingView(frame: .zero)
	private var itemColorImage 	= UIImage(systemName: Constants.colorImageName)?.withTintColor(.magenta)

	private var searchBar: UISearchBar = {
		let bar 			= UISearchBar()
		bar.placeholder 	= Constants.searchPlaceHolder
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
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.categoryCellId)
	}

	// MARK: - TableViewDataSource methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// If product list is filtered as per user's search, the table shows the search results
		let rowsCount = listIsFiltered ? filteredData.count : productsArray.count
		return rowsCount
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		animateLoading()
		let arrayForDisplay = listIsFiltered ? filteredData : productsArray
		let cell 					= UITableViewCell(style: .subtitle, reuseIdentifier: Constants.categoryCellId)
		let manufacturer 			= arrayForDisplay[indexPath.row].manufacturer.rawValue
		let price 					= String(arrayForDisplay[indexPath.row].price)
		cell.imageView?.image 		= Constants.getImageColored(color: arrayForDisplay[indexPath.row].color[0])
		cell.textLabel?.text 		= arrayForDisplay[indexPath.row].name
		cell.accessoryType 			= .disclosureIndicator
		cell.detailTextLabel?.text 	= "price: \(price), manufacturer: \(manufacturer)"
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let arrayForDisplay = listIsFiltered ? filteredData : productsArray
		repository.fetchAvailability(for: arrayForDisplay[indexPath.row])
		detailsViewController = DetailsViewController(product: arrayForDisplay[indexPath.row], category: self)
		if let detailsViewController = detailsViewController {
			self.navigationController?.pushViewController(detailsViewController,
														  animated: true)
		}
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
	// MARK: - Methods called from Repository
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
		detailsViewController?.didFailWithError(error: error)
	}
	// MARK: - Methods called from Repository
	func tryFetchAvailability(for product: Product) {
		repository.fetchAvailability(for: product)
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
