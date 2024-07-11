//
//  FavoritesViewModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 9.07.2024.
//

import Foundation
import UIKit
import CoreData

class FavoritesViewModel {

    private var imageItems: [ImageItem] = []  // Store corresponding ImageItems
    private var favorites: [Favorite] = []
    private let context: NSManagedObjectContext

    init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetchFavorites()
    }

    var numberOfFavorites: Int {
        return favorites.count
    }

    func favorite(at indexPath: IndexPath) -> Favorite {
        return favorites[indexPath.item]
    }
    
    func imageItem(at indexPath: IndexPath) -> ImageItem {
            return imageItems[indexPath.item]
        }

    func fetchFavorites() {
            let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]

            do {
                favorites = try context.fetch(fetchRequest)
                imageItems = favorites.map { favorite in
                    // Assuming you have a way to create an ImageItem from a Favorite
                    ImageItem(id: Int(favorite.id), previewURL: favorite.imageUrl ?? "", previewWidth: Int(favorite.previewWidth), previewHeight: Int(favorite.previewHeight), likes: Int(favorite.likes), comments: 0, views: Int(favorite.views), webformatURL: favorite.webFormatUrl ?? "", userImageURL: favorite.userImageUrl ?? "",user: favorite.user ?? "", downloads: Int(favorite.downloads), tags: favorite.tags ?? "")
                }
            } catch {
                print("Failed to fetch favorites: \(error)")
            }
        }

    func deleteFavorite(at indexPath: IndexPath) {
        let favorite = favorites[indexPath.item]
        context.delete(favorite)
        saveContext()
        fetchFavorites()
    }

    func updateFavorite(at indexPath: IndexPath, isFavorite: Bool) {
        favorites[indexPath.item].isLiked = isFavorite
        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    
}
