//
//  SearchScreenImageCell.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 5.07.2024.
//

import UIKit
import Kingfisher

class SearchCell: UICollectionViewCell {
    var imageView: UIImageView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
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


        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }

    func configure(with item: ImageItem) {
        imageView.kf.setImage(with: URL(string: item.webformatURL))
    }
}
