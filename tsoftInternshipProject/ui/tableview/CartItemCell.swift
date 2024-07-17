//
//  CartCell.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 17.07.2024.
//

import UIKit

class CartItemCell: UICollectionViewCell {
    private var imageView: UIImageView!
    private var priceLabel: UILabel!
    private var quantityLabel: UILabel!
    private var increaseButton: UIButton!
    private var decreaseButton: UIButton!
    private var deleteButton: UIButton!
    
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
        
        priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        
        quantityLabel = UILabel()
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(quantityLabel)
        
        increaseButton = UIButton(type: .system)
        increaseButton.setTitle("+", for: .normal)
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(increaseButton)
        
        decreaseButton = UIButton(type: .system)
        decreaseButton.setTitle("-", for: .normal)
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(decreaseButton)
        
        deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            quantityLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10),
            quantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            increaseButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 10),
            increaseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            increaseButton.widthAnchor.constraint(equalToConstant: 30),
            increaseButton.heightAnchor.constraint(equalToConstant: 30),
            
            decreaseButton.leadingAnchor.constraint(equalTo: increaseButton.trailingAnchor, constant: 10),
            decreaseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            decreaseButton.widthAnchor.constraint(equalToConstant: 30),
            decreaseButton.heightAnchor.constraint(equalToConstant: 30),
            
            deleteButton.leadingAnchor.constraint(equalTo: decreaseButton.trailingAnchor, constant: 10),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 50),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func configure(with item: CartItem, index: Int, target: CartViewController) {
        imageView.image = item.image
        priceLabel.text = String(format: "$%.2f", item.price)
        quantityLabel.text = "\(item.quantity)"
        increaseButton.tag = index
        increaseButton.addTarget(target, action: #selector(target.increaseQuantity(_:)), for: .touchUpInside)
        decreaseButton.tag = index
        decreaseButton.addTarget(target, action: #selector(target.decreaseQuantity(_:)), for: .touchUpInside)
        deleteButton.tag = index
        deleteButton.addTarget(target, action: #selector(target.deleteItem(_:)), for: .touchUpInside)
    }
}
