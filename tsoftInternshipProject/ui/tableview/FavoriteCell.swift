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
        contentView.addSubview(imageView)

        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        viewsLabel.text = "Views"
        likesLabel.text = "Likes"
        tagsLabel.text = "Tags"

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

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/3),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),

            priceLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),

            favoriteButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            favoriteButton.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),

            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }

    private func updateFavoriteIcon() {
        guard let viewModel = viewModel else { return }
        if viewModel.isLiked {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = .red
            manager?.addLike(viewModel.item)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = .white
            manager?.removeLike(Int(viewModel.id))
        }
    }
    
    @objc private func favoriteButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.isLiked.toggle()
        updateFavoriteIcon()
    }

    func configure(with favorite: Favorite, imageItem: ImageItem) {
        viewModel = FavoriteCellViewModel(favorite: favorite, item: imageItem)
        imageView.kf.setImage(with: URL(string: viewModel?.imageUrl ?? ""))
        viewsLabel.text = "Views: \(viewModel?.views ?? 0)"
        likesLabel.text = viewModel?.likes
        tagsLabel.text = "Tags: \(viewModel?.tags ?? "")"
        priceLabel.text = viewModel?.idWithDecimal
        favoriteButton.isSelected = viewModel?.isLiked ?? false
    }
}
protocol FavoriteCellDelegate: AnyObject {
    func didTapFavoriteButton(cell: FavoriteCell, isFavorite: Bool)
    func didRemoveFavorite(cell: FavoriteCell)
}
