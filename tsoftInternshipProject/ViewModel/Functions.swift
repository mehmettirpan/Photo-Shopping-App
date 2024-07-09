////
////  Functions.swift
////  tsoftInternshipProject
////
////  Created by Mehmet Tırpan on 9.07.2024.
////
//
//import Foundation
//import UIKit
//import CoreData
//import Kingfisher
//
//class Functions{
//    
//
//    
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard let query = searchBar.text, !query.isEmpty else {
//            // Search bar boş ise, başlangıç verilerini yükle veya ekranı temizle
//            fetchInitialData()
//            return
//        }
//
//        NetworkManager.shared.fetchImages(query: query) { result in
//            switch result {
//            case .success(let items):
//                self.items = items
//                self.collectionView.reloadData()
//            case .failure(let error):
//                print("Error fetching images: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    @objc func favoriteButtonTapped() {
//        guard let url = imageUrl else { return }
//        
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
//        context.perform {
//            if self.isImageLiked(url: url, in: context) {
//                self.removeLike(url: url, in: context)
//            } else {
//                self.addLike(url: url, in: context)
//            }
//            
//            // UI güncellemeleri ana thread üzerinde yapılmalı
//            DispatchQueue.main.async {
//                self.updateFavoriteButtonTitle(in: context)
//            }
//        }
//    }
//    
//    
//    func isImageLiked(url: String, in context: NSManagedObjectContext) -> Bool {
//        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "imageUrl == %@", url)
//
//        do {
//            let results = try context.fetch(fetchRequest)
//            return results.count > 0
//        } catch {
//            print("Error fetching: \(error)")
//            return false
//        }
//    }
//
//    func addLike(url: String, in context: NSManagedObjectContext) {
//        let favorite = Favorite(context: context)
//        favorite.imageUrl = url
//        favorite.isLiked = true
//
//        do {
//            try context.save()
//            print("Favoriye eklendi: \(url)")
//        } catch {
//            print("Failed to save favorite: \(error)")
//        }
//    }
//
//    func removeLike(url: String, in context: NSManagedObjectContext) {
//        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "imageUrl == %@", url)
//
//        do {
//            let results = try context.fetch(fetchRequest)
//
//            if let favorite = results.first {
//                context.delete(favorite)
//                try context.save()
//                print("Favoriden çıkarıldı: \(url)")
//            }
//        } catch {
//            print("Failed to delete favorite: \(error)")
//        }
//    }
//    
//    func updateFavoriteButtonTitle(in context: NSManagedObjectContext) {
//        guard let url = imageUrl else { return }
//
//        if isImageLiked(url: url, in: context) {
//            favoriteButton.setTitle("Reject Favorites", for: .normal)
//            favoriteButton.backgroundColor = UIColor.red
//            favoriteButton.tintColor = UIColor.white
//        } else {
//            favoriteButton.setTitle("Add Favorite", for: .normal)
//            favoriteButton.backgroundColor = UIColor.systemGray
//            favoriteButton.tintColor = UIColor.white
//        }
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
//    }
//    
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let query = searchBar.text, !query.isEmpty else { return }
//        NetworkManager.shared.fetchImages(query: query) { result in
//            switch result {
//            case .success(let items):
//                self.items = items
//                self.collectionView.reloadData()
//            case .failure(let error):
//                print("Error fetching images: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    
//    
//    
//}
//
