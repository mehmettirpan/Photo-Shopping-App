//
//  DetailViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 4.07.2024.
//
import UIKit
import Kingfisher
import CoreData

class DetailViewController: UIViewController {
    var imageView: UIImageView!
    var userImageView: UIImageView!
    var userLabel: UILabel!
    var likesLabel: UILabel!
    var commentsLabel: UILabel!
    var viewsLabel: UILabel!
    var downloadsLabel: UILabel!
    var tagsLabel: UILabel!
    var favoriteButton: UIButton!
    var webformatUrl: String! // URL to be set from FavoritesViewController
    var item: ImageItem! // Assuming ImageItem has properties for likes, comments, views, downloads, tags
    var imageUrl: String?




    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configure(with: item)
    }

    func setupViews() {
            view.backgroundColor = .systemBackground

            // Image View
            imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)

            // User Image View
            userImageView = UIImageView()
            userImageView.contentMode = .scaleAspectFill
            userImageView.clipsToBounds = true
            userImageView.layer.cornerRadius = 25
            userImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(userImageView)

            // User Label
            userLabel = UILabel()
            userLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(userLabel)

            // Likes Label
            likesLabel = UILabel()
            likesLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(likesLabel)

            // Comments Label
            commentsLabel = UILabel()
            commentsLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(commentsLabel)

            // Views Label
            viewsLabel = UILabel()
            viewsLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(viewsLabel)

            // Downloads Label
            downloadsLabel = UILabel()
            downloadsLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(downloadsLabel)

            // Tags Label
            tagsLabel = UILabel()
            tagsLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(tagsLabel)

            // Favorite Button
            favoriteButton = UIButton(type: .system)
            favoriteButton.setTitle("Add Favorite", for: .normal)
            favoriteButton.backgroundColor = .gray
            favoriteButton.tintColor = .white
            favoriteButton.layer.cornerRadius = 10
            favoriteButton.translatesAutoresizingMaskIntoConstraints = false
            favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
            view.addSubview(favoriteButton)

            NSLayoutConstraint.activate([
                // Image View constraints
                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.75),

                // User Image View constraints
                userImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
                userImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                userImageView.widthAnchor.constraint(equalToConstant: 50),
                userImageView.heightAnchor.constraint(equalToConstant: 50),

                // User Label constraints
                userLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
                userLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 20),
                userLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                // Likes Label constraints
                likesLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
                likesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                likesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                // Comments Label constraints
                commentsLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 8),
                commentsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                commentsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                // Views Label constraints
                viewsLabel.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor, constant: 8),
                viewsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                viewsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                // Downloads Label constraints
                downloadsLabel.topAnchor.constraint(equalTo: viewsLabel.bottomAnchor, constant: 8),
                downloadsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                downloadsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                // Tags Label constraints
                tagsLabel.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: 8),
                tagsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                tagsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                // Favorite Button constraints
                favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                favoriteButton.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 20),
                favoriteButton.widthAnchor.constraint(equalToConstant: 150),
                favoriteButton.heightAnchor.constraint(equalToConstant: 40)
            ])
        }


    func configure(with item: ImageItem) {
        imageView.kf.setImage(with: URL(string: item.webformatURL)) // webformatUrl kullanıldı
        userLabel.text = "User: \(item.user)"
        userImageView.kf.setImage(with: URL(string: item.userImageURL))
        likesLabel.text = "Likes: \(item.likes)"
        commentsLabel.text = "Comments: \(item.comments)"
        viewsLabel.text = "Views: \(item.views)"
        downloadsLabel.text = "Downloads: \(item.downloads)"
        tagsLabel.text = "Tags: \(item.tags)"
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
    
    func updateFavoriteButtonTitle(in context: NSManagedObjectContext) {
        guard let url = imageUrl else { return }

        if isImageLiked(url: url, in: context) {
            favoriteButton.setTitle("Reject Favorites", for: .normal)
        } else {
            favoriteButton.setTitle("Add Favorite", for: .normal)
        }
    }
}
