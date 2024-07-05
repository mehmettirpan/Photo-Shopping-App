//
//  ImageCell.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 4.07.2024.
//

import UIKit
import Kingfisher

class ListImageCell: UICollectionViewCell {
    var imageView: UIImageView!
    var likesLabel: UILabel!
    var commentsLabel: UILabel!
    var viewsLabel: UILabel!


    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupView()

        
        // ImageView
        imageView = UIImageView(frame: .zero) // UIImageView oluşturulur ve başlangıçta sıfır boyutunda olur
        imageView.contentMode = .scaleAspectFit // Görüntüdeki orijinallik korunur
        imageView.clipsToBounds = true // Görüntü, UIImageView sınırlarının dışına taşarsa kırpılır
        imageView.translatesAutoresizingMaskIntoConstraints = false // Otomatik yerleşim kısıtlamaları kullanılacak
        contentView.addSubview(imageView) // UIImageView, contentView'a eklenir
        
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
        
        // Layout constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor), // imageView'in üst kısmını contentView'in üst kısmına hizalar
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), // imageView'in sol kenarını contentView'in sol kenarına hizalar
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor), // imageView'in sağ kenarını contentView'in sağ kenarına hizalar
            imageView.heightAnchor.constraint(equalToConstant: 200), // imageView'in yüksekliğini 100 point olarak sabitler
            
            likesLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            likesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            commentsLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 4),
            commentsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            commentsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            viewsLabel.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor, constant: 4),
            viewsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            viewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            viewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: ImageItem) {
        imageView.kf.setImage(with: URL(string: item.previewURL))
        likesLabel.text = "Likes: \(item.likes)"
        commentsLabel.text = "Comments: \(item.comments)"
        viewsLabel.text = "Views: \(item.views)"
    }
    
//    func setupView(){
//        
////        likesLabel.translatesAutoresizingMaskIntoConstraints = false
////        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
////        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        stackView = UIStackView(arrangedSubviews: [likesLabel,commentsLabel,viewsLabel])
//        stackView.axis = .horizontal
//        stackView.spacing = 8
//        stackView.alignment = .leading
//        stackView.distribution = .fillProportionally
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
//        ])
//    }
    
}
