//
//  ViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 3.07.2024.
//


import UIKit
import Kingfisher

class ListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView!
    var items: [ImageItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchImages()
        collectionView.backgroundColor = UIColor.systemBackground
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ListImageCell
        let item = items[indexPath.item]
        cell.configure(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        let detailVC = DetailViewController()
        detailVC.item = item
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.item]
        let width = collectionView.frame.size.width - 20 // Tek sütun, yanlardan 10 piksel boşluk
        let aspectRatio = CGFloat(item.previewHeight) / CGFloat(item.previewWidth)
        let imageHeight = width * aspectRatio
        return CGSize(width: width, height: 270)
    }
    
    
}
