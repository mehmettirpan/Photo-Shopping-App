//
//  ListImageCell.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 5.07.2024.
//

import UIKit
import CoreData
import Kingfisher

class ListImageCell: UICollectionViewCell {
    var imageView: UIImageView!
    var likesLabel: UILabel!
    var commentsLabel: UILabel!
    var viewsLabel: UILabel!
    var favoriteButton: UIButton!
    var imageUrl: String?

    override init(frame: CGRect) {
        super.init(frame: frame)

        // ImageView
        imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        // Likes Label
        likesLabel = UILabel(frame: .zero)
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(likesLabel)

        // Comments Label
        commentsLabel = UILabel(frame: .zero)
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(commentsLabel)

        // Views Label
        viewsLabel = UILabel(frame: .zero)
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(viewsLabel)

        // Favorite Button
        favoriteButton = UIButton(type: .system)
        favoriteButton.setTitle("Add Favorites", for: .normal)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        contentView.addSubview(favoriteButton)

        // Layout constraints for ImageView
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 210)
        ])

        // Likes Label StackView
        let likesStackView = UIStackView()
        likesStackView.translatesAutoresizingMaskIntoConstraints = false
        likesStackView.axis = .horizontal
        likesStackView.spacing = 8
        likesStackView.alignment = .center
        likesStackView.distribution = .fillProportionally

        // Likes Label
        likesLabel = UILabel()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.font = UIFont.systemFont(ofSize: 14)
        likesLabel.text = "Likes: "
        likesStackView.addArrangedSubview(likesLabel)

        // Comments Label
        commentsLabel = UILabel()
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsLabel.font = UIFont.systemFont(ofSize: 14)
        commentsLabel.text = "Comments: "
        likesStackView.addArrangedSubview(commentsLabel)

        // Views Label
        viewsLabel = UILabel()
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.font = UIFont.systemFont(ofSize: 14)
        viewsLabel.text = "Views: "
        likesStackView.addArrangedSubview(viewsLabel)

        contentView.addSubview(likesStackView)

        // Constraints for Likes StackView
        NSLayoutConstraint.activate([
            likesStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            likesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            likesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            likesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        // Constraints for Favorite Button
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: ImageItem, context: NSManagedObjectContext) {
        imageView.kf.setImage(with: URL(string: item.previewURL))
        likesLabel.text = "Likes: \(item.likes)"
        commentsLabel.text = "Comments: \(item.comments)"
        viewsLabel.text = "Views: \(item.views)"
        imageUrl = item.previewURL

        // Update like button title
        updateFavoriteButtonTitle(in: context)
    }

    @objc func favoriteButtonTapped() {
        guard let url = imageUrl else { return }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        context.perform {
            if self.isImageLiked(url: url, in: context) {
                self.removeLike(url: url, in: context)
            } else {
                self.addLike(url: url, in: context)
            }

            // UI güncellemeleri ana thread üzerinde yapılmalı
            DispatchQueue.main.async {
                self.updateFavoriteButtonTitle(in: context)
            }
        }
    }

    func isImageLiked(url: String, in context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imageUrl == %@", url)

        do {
            let results = try context.fetch(fetchRequest)
            return results.count > 0
        } catch {
            print("Error fetching: \(error)")
            return false
        }
    }

    func addLike(url: String, in context: NSManagedObjectContext) {
        let favorite = Favorite(context: context)
        favorite.imageUrl = url
        favorite.isLiked = true

        do {
            try context.save()
            print("Favoriye eklendi: \(url)")
        } catch {
            print("Failed to save favorite: \(error)")
        }
    }

    func removeLike(url: String, in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imageUrl == %@", url)

        do {
            let results = try context.fetch(fetchRequest)

            if let favorite = results.first {
                context.delete(favorite)
                try context.save()
                print("Favoriden çıkarıldı: \(url)")
            }
        } catch {
            print("Failed to delete favorite: \(error)")
        }
    }
    
    func updateFavoriteButtonTitle(in context: NSManagedObjectContext) {
        guard let url = imageUrl else { return }

        if isImageLiked(url: url, in: context) {
            favoriteButton.setTitle("Reject Favorites", for: .normal)
        } else {
            favoriteButton.setTitle("Add Favorites", for: .normal)
        }
    }
}
