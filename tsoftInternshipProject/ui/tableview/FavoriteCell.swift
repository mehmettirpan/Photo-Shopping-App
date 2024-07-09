//
//  FavoriteCell.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 8.07.2024.
//

import UIKit
import Kingfisher
import CoreData



class FavoriteCell: UICollectionViewCell {

    weak var collectionView: UICollectionView?
    var imageView: UIImageView!
    var likesLabel: UILabel!
    var favoriteButton: UIButton!
    var favorite: Favorite?
    



    override init(frame: CGRect) {
        super.init(frame: frame)

        // Favoriten çıkar butonu
        favoriteButton = UIButton(type: .system)
        favoriteButton.setTitle("Reject Favorites", for: .normal)
        favoriteButton.tintColor = UIColor.red

        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        contentView.addSubview(favoriteButton)

        // Constraints for Favorite Button
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        // ImageView
        imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        // Likes Label
        likesLabel = UILabel(frame: .zero)
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(likesLabel)

        // Constraints for ImageView and Likes Label
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 8),
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

    func configure(with favorite: Favorite, collectionView: UICollectionView) {
        self.favorite = favorite
        self.collectionView = collectionView
        
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
    
    @objc func favoriteButtonTapped() {
        guard let imageUrl = favorite?.imageUrl else { return }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        context.perform {
            self.removeLike(url: imageUrl, in: context)

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
    
}
