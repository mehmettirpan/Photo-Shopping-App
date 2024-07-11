//
//  FavoriteManager.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 9.07.2024.
//

import Foundation
import CoreData
import UIKit

class FavoriteManager {
    static let shared = FavoriteManager()

    private init() {}

    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func isImageLiked(_ id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            return results.count > 0
        } catch {
            print("Error fetching: \(error)")
            return false
        }
    }

    func addLike(_ imageItem: ImageItem) {
        let favorite = Favorite(context: context)
        favorite.id = Int64(imageItem.id)
        favorite.isLiked = true
        favorite.imageUrl = imageItem.webformatURL
        favorite.views = Int64(imageItem.views)
        favorite.likes = Int64(imageItem.likes)
        favorite.tags = imageItem.tags

        do {
            try context.save()
            print("Favoriye eklendi: \(imageItem.id)")
        } catch {
            print("Failed to save favorite: \(error)")
        }
    }

    func removeLike(_ id: Int) {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)

            if let favorite = results.first {
                context.delete(favorite)
                try context.save()
                print("Favoriden çıkarıldı: \(id)")
            }
        } catch {
            print("Failed to delete favorite: \(error)")
        }
    }
}
