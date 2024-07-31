//
//  FavoriteCell.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 8.07.2024.
//

import UIKit
import Kingfisher

class FavoriteCell: UICollectionViewCell {
    
    var viewModel: FavoriteCellViewModel?
    let priceLabel = UILabel()
    let tagsLabel = UILabel()
    let likesLabel = UILabel()
    let viewsLabel = UILabel()
    var imageView: UIImageView!
    var favoriteButton: UIButton!
    var addToCartButton: UIButton!
    weak var delegate: FavoriteCellDelegate?
    let stackView = UIStackView()
    var manager: FavoriteManager?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        manager = FavoriteManager.shared
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 4
        contentView.addSubview(imageView)

        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        viewsLabel.text = "Views"
        likesLabel.text = "Likes"
        tagsLabel.text = "Tags"
        tagsLabel.numberOfLines = 2

        stackView.addArrangedSubview(viewsLabel)
        stackView.addArrangedSubview(likesLabel)
        stackView.addArrangedSubview(tagsLabel)

        priceLabel.font = .systemFont(ofSize: 20, weight: .bold)
        priceLabel.text = "Price"
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)

        favoriteButton = UIButton(type: .custom)
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .red
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favoriteButton)

        addToCartButton = UIButton(type: .system)
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = UIColor(named: "ButtonColor")
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addToCartButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/3),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            priceLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),

            favoriteButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            favoriteButton.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),

            addToCartButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            addToCartButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            addToCartButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2),
            addToCartButton.heightAnchor.constraint(equalToConstant: 30),

            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }

    @objc private func favoriteButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.isLiked.toggle()
        updateFavoriteIcon()
        delegate?.didTapFavoriteButton(cell: self, isFavorite: viewModel.isLiked)
    }

    private func updateFavoriteIcon() {
        guard let viewModel = viewModel else { return }
        favoriteButton.isSelected = viewModel.isLiked
    }

    @objc private func addToCartButtonTapped() {
        animateButtonTitleChange()
        guard let viewModel = viewModel else {
            print("Error: viewModel is nil")
            return
        }
        
        // Ensure imageView has an image
        guard let image = imageView.image else {
            print("Error: Image view does not have an image")
            return
        }
        
        // Ensure price is correctly formatted and converted
        guard let price = Double(viewModel.idWithDecimal) else {
            print("Error: Could not convert idWithDecimal to price")
            return
        }
        
        // Create a cart item
        let cartItem = CartItem(id: Int(viewModel.id), image: image, price: price, quantity: 1, tags: viewModel.tags ?? "")
        
        // Add to cart and print the cart state
        CartViewModel.shared.addItem(cartItem)
        print("Added item to cart: \(cartItem)")
        print("Current cart items: \(CartViewModel.shared.cartItems)")
    }

    func configure(with favorite: Favorite, imageItem: ImageItem) {
        viewModel = FavoriteCellViewModel(favorite: favorite, item: imageItem)
        imageView.kf.setImage(with: URL(string: viewModel?.imageUrl ?? ""))
        viewsLabel.text = "Views: \(viewModel?.views ?? 0)"
        likesLabel.text = viewModel?.likes
        tagsLabel.text = "Tags: \(viewModel?.tags ?? "")"
        priceLabel.text = "\(viewModel!.idWithDecimal)$"
        favoriteButton.isSelected = viewModel?.isLiked ?? false
    }
    
    private func animateButtonTitleChange() {
        UIView.transition(with: addToCartButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.addToCartButton.setTitle("Added to Cart", for: .normal)
            self.addToCartButton.backgroundColor = .systemGray
        }) { _ in
            // Revert back to original title after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.transition(with: self.addToCartButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.addToCartButton.setTitle("Add to Cart", for: .normal)
                    self.addToCartButton.backgroundColor = UIColor(named: "ButtonColor")
                })
            }
        }
    }
}

protocol FavoriteCellDelegate: AnyObject {
    func didTapFavoriteButton(cell: FavoriteCell, isFavorite: Bool)
    func didRemoveFavorite(cell: FavoriteCell)
}
