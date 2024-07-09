//
//  SearchListViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 4.07.2024.
//

import UIKit
import Kingfisher

class SearchListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var searchBar: UISearchBar!
    var collectionView: UICollectionView!
    var items: [ImageItem] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        fetchImages()
    }

    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text, !query.isEmpty else {
            // Search bar boş ise, başlangıç verilerini yükle veya ekranı temizle
            fetchInitialData()
            return
        }

        NetworkManager.shared.fetchImages(query: query) { result in
            switch result {
            case .success(let items):
                self.items = items
                self.collectionView.reloadData()
            case .failure(let error):
                print("Error fetching images: \(error.localizedDescription)")
            }
        }
    }

    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchImageCell.self, forCellWithReuseIdentifier: "SearchScreenImageCell")
        collectionView.backgroundColor = .systemBackground
        self.view.addSubview(collectionView)
    }
    
    func fetchImages() {
        NetworkManager.shared.fetchImages { result in
            switch result {
            case .success(let items):
                self.items = items
                self.collectionView.reloadData()
            case .failure(let error):
                print("Error fetching images: \(error.localizedDescription)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchScreenImageCell", for: indexPath) as! SearchImageCell
        let item = items[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.item]
//        let width = collectionView.frame.size.width - 20 // Tek sütun, yanlardan 10 piksel boşluk
        let aspectRatio = CGFloat(item.previewHeight) / CGFloat(item.previewWidth)
        let imageHeight = 120 * aspectRatio
        return CGSize(width: 120, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        let detailVC = DetailViewController()
        detailVC.item = item
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func fetchInitialData() {
        // Başlangıç verilerini yükle veya ekranı temizle için fonksiyon
        items.removeAll() // Örneğin, mevcut öğeleri temizle
        fetchImages()  // geri eski dosyaları yüklemesi için bunu çağırdık
        }
    
}
