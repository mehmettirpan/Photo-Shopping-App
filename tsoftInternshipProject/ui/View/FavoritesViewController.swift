//
//  FavoritesViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 5.07.2024.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {

    var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl!
    var viewModel: FavoritesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        viewModel = FavoritesViewModel()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 32, height: 200)
        layout.minimumLineSpacing = 16
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: "FavoriteCell")
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFavorites), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        fetchFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }

    @objc func refreshFavorites() {
        fetchFavorites()
        refreshControl.endRefreshing()
    }

    func fetchFavorites() {
        viewModel.fetchFavorites()
        collectionView.reloadData()
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfFavorites
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let favorite = viewModel.favorite(at: indexPath)
        let imageItem = viewModel.imageItem(at: indexPath)
        cell.configure(with: favorite, imageItem: imageItem)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension FavoritesViewController: FavoriteCellDelegate {
    func didRemoveFavorite(cell: FavoriteCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            viewModel.deleteFavorite(at: indexPath)
            collectionView.deleteItems(at: [indexPath])
        }
    }
    
    func didTapFavoriteButton(cell: FavoriteCell, isFavorite: Bool) {
        if let indexPath = collectionView.indexPath(for: cell) {
            viewModel.updateFavorite(at: indexPath, isFavorite: isFavorite)
            fetchFavorites() // Ensure the collection view is reloaded after favorite status change
        }
    }
}
