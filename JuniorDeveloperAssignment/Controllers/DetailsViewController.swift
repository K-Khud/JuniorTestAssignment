//
//  DetailsViewController.swift
//  ReaktorJDAssignment
//
//  Created by Ekaterina Khudzhamkulova on 28.11.2020.
//

import UIKit

protocol IDetailsViewController {
	func updateData(with product: Product)
	func didFailWithError(error: Error)
}

class DetailsViewController: UIViewController, UITableViewDelegate {
	private var category: ICategoryViewController?
	private var productForInspection: Product
	private var tableView 			= UITableView()
	private let alert 				= UIAlertController(title: Constants.alertTitle,
													  message: Constants.alertMessage, preferredStyle: .alert)
	private let activityView 		= UIActivityIndicatorView(style: .medium)

	private var titleLabel: UILabel = {
		let label 				= UILabel()
		label.textAlignment 	= .left
		label.font 				= .boldSystemFont(ofSize: 32)
		label.numberOfLines 	= 0
		label.backgroundColor 	= .clear
		label.textColor 		= .systemPink
		label.text 				= Constants.detailsTitle
		return label
	}()

	private var textLabel: UILabel = {
		let label 				= UILabel()
		label.textAlignment 	= .left
		label.font 				= .systemFont(ofSize: 20)
		label.numberOfLines 	= 0
		label.backgroundColor 	= .clear
		label.textColor 		= UIColor.black
		return label
	}()

	init(product: Product, category: ICategoryViewController) {
		self.productForInspection = product
		super.init(nibName: nil, bundle: nil)
		self.category = category
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor 	= .systemBackground
		tableView.dataSource 		= self
		tableView.delegate 			= self
		registerCells()
		setupTitleLabel()
		setupLabel()
		setupTableView()
		setupAlert()
	}

	private func setupTitleLabel() {
		view.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints 														= false
		titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive 		= true
		titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive 		= true
		titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive	= true
	}

	private func setupLabel() {
		view.addSubview(textLabel)
		textLabel.translatesAutoresizingMaskIntoConstraints 													= false
		textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive	 				= true
		textLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive 	= true
		textLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
	}

	private func setupTableView() {
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints 										= false
		tableView.topAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive	 				= true
		tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive 		= true
		tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive 	= true
		tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive 	= true
		tableView.tableFooterView = UIView()
		view.layoutSubviews()
	}
	private func setupAlert() {
		let tryAction = UIAlertAction(title: Constants.alertTryTitle, style: .default) { [] (_) in
			self.category?.tryFetchAvailability(for: self.productForInspection)
		}
		let cancelAction = UIAlertAction(title: Constants.alertCancelTitle, style: .cancel) { (_) in
			self.tableView.reloadData()
		}
		alert.addAction(tryAction)
		alert.addAction(cancelAction)
	}
}

// MARK: - UITableViewDataSource methods
extension DetailsViewController: UITableViewDataSource {
	private func registerCells() {
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.detailsCellId)
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 7
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: Constants.detailsCellId)
		var detailDescription = ""
		switch indexPath.row {
		case 0: detailDescription = productForInspection.type.rawValue
		case 1: detailDescription = productForInspection.name
		case 2: detailDescription = productForInspection.color[0].rawValue
		case 3: detailDescription = productForInspection.id
		case 4: detailDescription = String(productForInspection.price)
		case 5: detailDescription = productForInspection.manufacturer.rawValue
		case 6:
			// Display loading indicator when availability is being fetched
			if let availability = productForInspection.availability {
				detailDescription = availability
				activityView.stopAnimating()
			} else if activityView.isAnimating {
				activityView.stopAnimating()
				detailDescription = "no info"
			} else {
				activityView.startAnimating()
				cell.accessoryView = activityView
			}
		default: detailDescription = "no info"
		}
		cell.textLabel?.text = Constants.detailsNames[indexPath.row] + detailDescription
		return cell
	}
}

// MARK: - IDetailsViewController methods
extension DetailsViewController: IDetailsViewController {
	func updateData(with product: Product) {
		productForInspection = product
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	func didFailWithError(error: Error) {
		DispatchQueue.main.async {
			self.present(self.alert, animated: true, completion: nil)
		}
	}
}
