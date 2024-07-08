//
//  ViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 3.07.2024.
//


import UIKit
import Kingfisher
import CoreData

class ListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView!
    var items: [ImageItem] = []
    var refreshControl: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchData {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        collectionView.backgroundColor = UIColor.systemBackground
        
        refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
            collectionView.refreshControl = refreshControl
        
    }

    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ListImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.backgroundColor = .white
        self.view.addSubview(collectionView)

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc func handleRefresh(_ sender: Any) {
        fetchData {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }

    private func fetchData(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchImages { result in
            switch result {
            case .success(let items):
                self.items = items
                completion()
            case .failure(let error):
                print("Error fetching images: \(error.localizedDescription)")
                completion()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ListImageCell
        let item = items[indexPath.item]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        cell.configure(with: item, context: context)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        let detailVC = DetailViewController()
        detailVC.item = item
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.item]
        let width = collectionView.frame.size.width - 20
        let aspectRatio = CGFloat(item.previewHeight) / CGFloat(item.previewWidth)
        let imageHeight = width * aspectRatio
        return CGSize(width: width, height: 270)
    }
}

//extension ListViewController: ListViewControllerDelegate {
//    func reloadFavoritesView() {
//        collectionView.reloadData()
//    }
//}
