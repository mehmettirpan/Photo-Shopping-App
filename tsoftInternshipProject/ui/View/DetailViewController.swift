//
//  DetailViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 4.07.2024.
//
import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    var imageView: UIImageView!
    var userImageView: UIImageView!
    var userLabel: UILabel!
    var item: ImageItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configure(with: item)
    }

    func setupViews() {
        view.backgroundColor = .systemBackground

        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        userImageView = UIImageView()
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 25 // Yuvarlak yapmak için yarıçap
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userImageView)

        userLabel = UILabel()
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.75), // Max 75% of the screen height

            userImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            userImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalToConstant: 50),

            userLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            userLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 20),
            userLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    func configure(with item: ImageItem) {
        imageView.kf.setImage(with: URL(string: item.previewURL))
        userLabel.text = "User: \(item.user)"
        userImageView.kf.setImage(with: URL(string: item.userImageURL))
    }
    
    
}
