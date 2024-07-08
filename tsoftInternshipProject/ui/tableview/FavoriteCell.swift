//
//  FavoriteCell.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 8.07.2024.
//

import UIKit
import Kingfisher

class FavoriteCell: UICollectionViewCell {

    var imageView: UIImageView!
    var likesLabel: UILabel!
    var favoriteButton: UIButton!


    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        likesLabel = UILabel(frame: .zero)
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(likesLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),

            likesLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            likesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with favorite: Favorite) {
        if let imageUrl = favorite.imageUrl {
            imageView.kf.setImage(with: URL(string: imageUrl))
        } else {
            imageView.image = nil
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        likesLabel.text = nil
    }
    
    
}
