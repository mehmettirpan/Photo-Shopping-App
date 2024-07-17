//
//  FavoriteCellViewModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 9.07.2024.
//

import Foundation
import UIKit
import CoreData

class FavoriteCellViewModel {
    
    var isLiked: Bool
    var favorite: Favorite
    var item: ImageItem

    init(favorite: Favorite, item: ImageItem) {
        self.favorite = favorite
        self.isLiked = favorite.isLiked
        self.item = item
    }

    var imageUrl: String? {
        return favorite.imageUrl
    }
    
    var id: Int64 {
        return favorite.id
    }
    
    var tags: String? {
        return item.tags
    }
    var views: Int64 {
        return favorite.views
    }

    var likes: String {
        return "Likes: \(item.likes)"
    }
    
    var idWithDecimal: String {
        let id = favorite.id
        let idFourDigit = id / 1000 // id değerinin ilk 4 hanesi
        let firstTwoDigits = String(format: "%02d", idFourDigit / 100)
        let lastTwoDigits = String(format: "%02d", idFourDigit % 100)
        return "\(firstTwoDigits).\(lastTwoDigits)"
    }
    
}
