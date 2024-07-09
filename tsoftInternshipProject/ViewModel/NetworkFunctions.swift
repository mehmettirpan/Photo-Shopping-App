////
////  NetworkFunctions.swift
////  tsoftInternshipProject
////
////  Created by Mehmet Tırpan on 9.07.2024.
////
//
//import Foundation
//import Kingfisher
//import CoreData
//import UIKit
//
//class NetworkFunctions{
//    
//    var items: [ImageItem] = []
//
//    
//    func fetchFavorites() {
//        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "imageUrl", ascending: true)]
//
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
////        fetchedResultsController.delegate = self
//
//        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
//                fetchRequest.sortDescriptors = [sortDescriptor]
//
//        do {
//            try fetchedResultsController.performFetch()
//            collectionView.reloadData()
//        } catch {
//            print("Failed to fetch favorites: \(error)")
//        }
//    }
//    
//    func fetchData(completion: @escaping () -> Void) {
//        NetworkManager.shared.fetchImages { result in
//            switch result {
//            case .success(let items):
//                self.items = items
//                completion()
//            case .failure(let error):
//                print("Error fetching images: \(error.localizedDescription)")
//                completion()
//            }
//        }
//    }
//    
//    
//    @objc func handleRefresh(_ sender: Any) {
//        fetchData {
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//                self.refreshControl?.endRefreshing()
//            }
//        }
//    }
//    
//    
//    func fetchImages() {
//        NetworkManager.shared.fetchImages { result in
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
//    func fetchInitialData() {
//        // Başlangıç verilerini yükle veya ekranı temizle için fonksiyon
//        items.removeAll() // Örneğin, mevcut öğeleri temizle
//        fetchImages()  // geri eski dosyaları yüklemesi için bunu çağırdık
//        }
//    
//    
//    
//    
//}
