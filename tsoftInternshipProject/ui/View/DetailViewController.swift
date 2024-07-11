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
    var viewModel: DetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configure()
        updateFavoriteButtonTitle()
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
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // Refresh data here
            configure()
            updateFavoriteButtonTitle()
        }


    func configure() {
        imageView.kf.setImage(with: URL(string: viewModel.imageUrl ?? ""))
        userLabel.text = viewModel.user
        userImageView.kf.setImage(with: URL(string: viewModel.userImageUrl ?? ""))
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        viewsLabel.text = viewModel.views
        downloadsLabel.text = viewModel.downloads
        tagsLabel.text = viewModel.tags
    }

    @objc func favoriteButtonTapped() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        viewModel.toggleFavorite(in: context) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.updateFavoriteButtonTitle()
                }
            case .failure(let error):
                print("Failed to toggle favorite: \(error)")
            }
        }
    }

    func updateFavoriteButtonTitle() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if viewModel.isImageLiked(in: context) {
            favoriteButton.setTitle("Reject Favorites", for: .normal)
            favoriteButton.backgroundColor = UIColor.red
            favoriteButton.tintColor = UIColor.white
        } else {
            favoriteButton.setTitle("Add Favorite", for: .normal)
            favoriteButton.backgroundColor = UIColor.systemGray
            favoriteButton.tintColor = UIColor.white
        }
    }
}
