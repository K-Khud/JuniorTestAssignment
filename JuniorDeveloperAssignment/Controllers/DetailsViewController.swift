//
//  DetailsViewController.swift
//  ReaktorJDAssignment
//
//  Created by Ekaterina Khudzhamkulova on 28.11.2020.
//

import UIKit

protocol IDetailsViewController {
	func updateData(with product: Product)
}

class DetailsViewController: UIViewController, UITableViewDelegate {
	private var tableView = UITableView()
	private var productForInspection: Product
	private var titleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = .boldSystemFont(ofSize: 32)
		label.numberOfLines = 0
		label.backgroundColor = .clear
		label.textColor = .systemPink
		label.text = "Product Info"
		return label
	}()

	private var textLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = .systemFont(ofSize: 20)
		label.numberOfLines = 0
		label.backgroundColor = .clear
		label.textColor = UIColor.black
		return label
	}()

	init(product: Product) {
		self.productForInspection = product
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .systemBackground
		tableView.dataSource = self
		tableView.delegate = self
		registerCells()
		setupTitleLabel()
		setupLabel()
		setupTableView()
	}

	private func setupTitleLabel() {
		view.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
		titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
	}

	private func setupLabel() {
		view.addSubview(textLabel)
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
		textLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
		textLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
	}

	private func setupTableView() {
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.topAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive = true
		tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		tableView.tableFooterView = UIView()
		view.layoutSubviews()
	}
}

// MARK: - UITableViewDataSource methods
extension DetailsViewController: UITableViewDataSource {
	private func registerCells() {
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "detailsCell")
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 7
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "detailsCell")
		switch indexPath.row {
		case 0: cell.textLabel?.text = "Type: \(productForInspection.type.rawValue)"
		case 1: cell.textLabel?.text = "Name: \(productForInspection.name)"
		case 2: cell.textLabel?.text = "Color: \(productForInspection.color[0].rawValue)"
		case 3: cell.textLabel?.text = "ID: \(productForInspection.id)"
		case 4: cell.textLabel?.text = "Price: \(String(productForInspection.price))"
		case 5: cell.textLabel?.text = "Manufacturer: \(productForInspection.manufacturer)"
		case 6:
			// Display loading indicator when availability is being fetched
			if let availability = productForInspection.availability {
				cell.textLabel?.text = "Availability: \(availability)"
			} else {
				cell.textLabel?.text = "Availability: "
				let activityView = UIActivityIndicatorView(style: .medium)
				activityView.startAnimating()
				cell.accessoryView = activityView
			}
		default: cell.textLabel?.text = "no info"
		}
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
}
