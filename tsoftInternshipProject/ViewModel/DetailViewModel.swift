//
//  DetailViewModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 9.07.2024.
//

//import Foundation
//import CoreData
//
//class DetailViewModel {
//
//    var manager: FavoriteManager?
//    
//    var item: ImageItem
//
//    init(item: ImageItem) {
//        self.item = item
//    }
//
//    var imageUrl: String? {
//        return item.webformatURL
//    }
//    
//    var id: Int {
//        return item.id
//    }
//
//    var user: String {
//        return "User: \(item.user)"
//    }
//
//    var userImageUrl: String? {
//        return item.userImageURL
//    }
//
//    var likes: String {
//        return "Likes: \(item.likes)"
//    }
//
//    var comments: String {
//        return "Comments: \(item.comments)"
//    }
//
//    var views: String {
//        return "Views: \(item.views)"
//    }
//
//    var downloads: String {
//        return "Downloads: \(item.downloads)"
//    }
//
//    var tags: String {
//        return "Tags: \(item.tags)"
//    }
//
//    func isImageLiked(in context: NSManagedObjectContext) -> Bool {
//        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
//
//        do {
//            let results = try context.fetch(fetchRequest)
//            return results.first?.isLiked ?? false
//        } catch {
//            print("Error fetching favorites: \(error)")
//            return false
//        }
//    }
//
//    func toggleFavorite(in context: NSManagedObjectContext, completion: @escaping (Result<Bool, Error>) -> Void) {
//        context.perform {
//            if self.isImageLiked(in: context) {
//                self.removeLike(in: context)
//                completion(.success(false))
//            } else {
//                self.addLike(in: context)
//                completion(.success(true))
//            }
//        }
//    }
//
//    private func removeLike(in context: NSManagedObjectContext) {
//        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
//
//        do {
//            let results = try context.fetch(fetchRequest)
//            if let favorite = results.first {
//                context.delete(favorite)
//                try context.save()
//                print("Favoriden çıkarıldı: \(id)")
//            }
//        } catch {
//            print("Failed to delete favorite: \(error)")
//        }
//    }
//
//    private func addLike(in context: NSManagedObjectContext) {
//        let favorite = Favorite(context: context)
//        favorite.id = Int64(id)
//        favorite.isLiked = true
//        favorite.imageUrl = imageUrl // If needed
//
//        do {
//            try context.save()
//            print("Favoriye eklendi: \(id)")
//        } catch {
//            print("Failed to add favorite: \(error)")
//        }
//    }
//}


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
