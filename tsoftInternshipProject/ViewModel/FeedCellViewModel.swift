//
//  ListImageCellViewModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 9.07.2024.
//

import Foundation

class FeedCellViewModel {
    let imageItem: ImageItem
    var isLiked: Bool
    
    var idWithDecimal: String {
        let id = imageItem.id
        let idFourDigit = id / 1000 // id değerinin ilk 4 hanesi
        let firstTwoDigits = String(format: "%02d", idFourDigit / 100)
        let lastTwoDigits = String(format: "%02d", idFourDigit % 100)
        return "\(firstTwoDigits).\(lastTwoDigits)"
    }

    init(imageItem: ImageItem) {
        self.imageItem = imageItem
        self.isLiked = FavoriteManager.shared.isImageLiked(imageItem.id)
    }
    
    var previewURL: URL? {
        return URL(string: imageItem.previewURL)
    }

    var id: Int {
        return imageItem.id
    }

    func toggleFavoriteStatus() {
        let manager = FavoriteManager.shared
        if isLiked {
            manager.removeLike(imageItem.id)
        } else {
            manager.addLike(imageItem)
        }
        isLiked = !isLiked
    }
}
