//
//  DetailViewModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 9.07.2024.
//

import Foundation
import CoreData

class DetailViewModel {

    var manager: FavoriteManager?
    
    var item: ImageItem

    init(item: ImageItem) {
        self.item = item
        self.manager = FavoriteManager.shared
    }

    var imageUrl: String? {
        return item.webformatURL
    }
    
    var id: Int {
        return item.id
    }

    var user: String {
        return "User: \(item.user)"
    }

    var userImageUrl: String? {
        return item.userImageURL
    }

    var likes: String {
        return "Likes: \(item.likes)"
    }

    var comments: String {
        return "Comments: \(item.comments)"
    }

    var views: String {
        return "Views: \(item.views)"
    }

    var downloads: String {
        return "Downloads: \(item.downloads)"
    }

    var tags: String {
        return "Tags: \(item.tags)"
    }

    func isImageLiked(in context: NSManagedObjectContext) -> Bool {
        return manager?.isImageLiked(id) ?? false
    }

    func toggleFavorite(in context: NSManagedObjectContext, completion: @escaping (Result<Bool, Error>) -> Void) {
        context.perform {
            if self.isImageLiked(in: context) {
                self.manager?.removeLike(self.id)
                completion(.success(false))
            } else {
                self.manager?.addLike(self.item)
                completion(.success(true))
            }
        }
    }
}
