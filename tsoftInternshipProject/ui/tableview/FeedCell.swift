//
//  ListImageCell.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 5.07.2024.
//

import UIKit
import Kingfisher

class FeedCell: UICollectionViewCell {
    // UI Elements
    private var imageView: UIImageView!
    private var priceLabel: UILabel!
    private var favoriteButton: UIButton!
    private var addToCartButton: UIButton!
    
    var manager: FavoriteManager?
    
    var viewModel: FeedCellViewModel? {
        didSet {
            configure()
        }
    }
    
    var detailViewModel: DetailViewModel? {
        didSet {
            configure()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(red: 0.91, green: 0.92, blue: 0.92, alpha: 1.0)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        // ImageView
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        // Price Label
        priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(priceLabel)
        
        // Add to Cart Button
        addToCartButton = UIButton(type: .system)
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = .systemOrange
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addToCartButton)
        
        // Favorite Button
        favoriteButton = UIButton(type: .system)
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .red
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favoriteButton)
        
        // Constraints for ImageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor) // Square image view
        ])
        
        // Constraints for Add to Cart Button
        NSLayoutConstraint.activate([
            addToCartButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            addToCartButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2),
            addToCartButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Constraints for Price Label
        NSLayoutConstraint.activate([
            priceLabel.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: addToCartButton.trailingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        // Constraints for Favorite Button
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func favoriteButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.toggleFavoriteStatus()
        updateFavoriteIcon()
        }
    
    private func updateFavoriteIcon() {
        guard let viewModel = viewModel else { return }
        if viewModel.isLiked {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = .red
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = .white
        }
    }
    
    public func configure() {
        guard let viewModel = viewModel else { return }
        imageView.kf.setImage(with: viewModel.previewURL)
        priceLabel.text = viewModel.idWithDecimal
        updateFavoriteIcon()
    }
}
