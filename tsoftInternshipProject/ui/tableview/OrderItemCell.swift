//
//  OrderItemCell.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 24.07.2024.
//

import UIKit

class OrderItemCell: UICollectionViewCell {
    private var imageView: UIImageView!
    private var nameLabel: UILabel!
    private var priceLabel: UILabel!
    private var quantityLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemBackground

        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)

        quantityLabel = UILabel()
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(quantityLabel)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: imageView.topAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),

            quantityLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10),
            quantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    func configure(with item: CartItem) {
        imageView.image = item.image
        nameLabel.text = item.tags.split(separator: " ").prefix(2).joined(separator: " ")
        priceLabel.text = String(format: "$%.2f", item.price)
        quantityLabel.text = "\(item.quantity)"
    }
}
