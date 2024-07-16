//
//  AddToCartViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 9.07.2024.
//

import UIKit

class CartViewController: UIViewController {
    private var viewModel: CartViewModel!
    private var stackView: UIStackView!
    private var totalPriceLabel: UILabel!
    private var confirmButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CartViewModel() // Or pass an instance if using dependency injection
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        totalPriceLabel = UILabel()
        totalPriceLabel.text = "Total: $0.00"
        totalPriceLabel.textAlignment = .right
        view.addSubview(totalPriceLabel)

        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalPriceLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            totalPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm Cart", for: .normal)
        confirmButton.backgroundColor = .systemBlue
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 8
        confirmButton.addTarget(self, action: #selector(confirmCart), for: .touchUpInside)
        view.addSubview(confirmButton)

        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 20),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        reloadCart()
    }

    private func reloadCart() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (index, item) in viewModel.cartItems.enumerated() {
            let itemView = createCartItemView(for: item, at: index)
            stackView.addArrangedSubview(itemView)
        }
        totalPriceLabel.text = "Total: $\(viewModel.totalPrice())"
    }

    private func createCartItemView(for item: CartItem, at index: Int) -> UIView {
        let containerView = UIView()
        containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        let imageView = UIImageView(image: item.image)
        containerView.addSubview(imageView)

        let priceLabel = UILabel()
        priceLabel.text = "$\(item.price * Double(item.quantity))"
        containerView.addSubview(priceLabel)

        let quantityLabel = UILabel()
        quantityLabel.text = "\(item.quantity)"
        quantityLabel.textAlignment = .center
        containerView.addSubview(quantityLabel)

        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.addTarget(self, action: #selector(increaseQuantity(_:)), for: .touchUpInside)
        plusButton.tag = index
        containerView.addSubview(plusButton)

        let minusButton = UIButton(type: .system)
        minusButton.setTitle("-", for: .normal)
        minusButton.addTarget(self, action: #selector(decreaseQuantity(_:)), for: .touchUpInside)
        minusButton.tag = index
        containerView.addSubview(minusButton)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            priceLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            minusButton.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10),
            minusButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            quantityLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor, constant: 10),
            quantityLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 40),

            plusButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 10),
            plusButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        return containerView
    }

    @objc private func increaseQuantity(_ sender: UIButton) {
        let index = sender.tag
        viewModel.updateQuantity(at: index, quantity: viewModel.cartItems[index].quantity + 1)
        reloadCart()
    }

    @objc private func decreaseQuantity(_ sender: UIButton) {
        let index = sender.tag
        viewModel.updateQuantity(at: index, quantity: viewModel.cartItems[index].quantity - 1)
        reloadCart()
    }

    @objc private func confirmCart() {
        // Implement the confirm cart functionality
        print("Cart confirmed with total price: \(viewModel.totalPrice())")
    }
}
