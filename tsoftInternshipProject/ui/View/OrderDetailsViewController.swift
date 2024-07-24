//
//  OrderDetailsViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 24.07.2024.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    var order: Order?

    private let productsHeadingLabel = UILabel()
    private let productsStackView = UIStackView()
    private let addressHeadingLabel = UILabel()
    private let addressLabel = UILabel()
    private let cardInfoHeadingLabel = UILabel()
    private let cardInfoLabel = UILabel()
    private let totalAmountLabel = UILabel()
    private let addedDateLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order Details"
        setupUI()
        updateUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Set up headings and labels
        productsHeadingLabel.text = "Products"
        productsHeadingLabel.font = .boldSystemFont(ofSize: 18)
        
        addressHeadingLabel.text = "Address"
        addressHeadingLabel.font = .boldSystemFont(ofSize: 18)
        
        cardInfoHeadingLabel.text = "Card Info"
        cardInfoHeadingLabel.font = .boldSystemFont(ofSize: 18)
        
        // Set up products stack view
        productsStackView.axis = .vertical
        productsStackView.spacing = 4
        
        // Set up main stack view
        let stackView = UIStackView(arrangedSubviews: [
            productsHeadingLabel,
            productsStackView,
            addressHeadingLabel,
            addressLabel,
            cardInfoHeadingLabel,
            cardInfoLabel,
            totalAmountLabel,
            addedDateLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func updateUI() {
        guard let order = order else { return }
        
        // Clear existing products
        productsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Update products stack view
        let productDescriptions = order.productNames?.components(separatedBy: "-") ?? []
        for description in productDescriptions {
            let productLabel = UILabel()
            productLabel.text = description.trimmingCharacters(in: .whitespacesAndNewlines)
            productLabel.font = .systemFont(ofSize: 16)
            productsStackView.addArrangedSubview(productLabel)
        }
        
        // Update other labels
        addressLabel.text = order.address ?? "N/A"
        cardInfoLabel.text = order.cardInfo ?? "N/A"
        totalAmountLabel.text = "Total: \(order.totalAmount)"
        addedDateLabel.text = "Date: \(formattedDate(from: order.addedDate))"
    }
    
    private func formattedDate(from date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
