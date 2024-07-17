//
//  ViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 3.07.2024.
//

import UIKit

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var collectionView: UICollectionView!
    private var viewModel: FeedViewModel!
    private var refreshControl: UIRefreshControl?
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FeedViewModel()
        setupCollectionView()
        setupRefreshControl()
        setupCartButton()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let itemWidth = (view.frame.width - 40) / 2 // Calculate item width for 2 columns
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3) // Adjust item height as needed
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.backgroundColor = UIColor.systemBackground
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh(_ sender: Any) {
        viewModel.resetData()
        fetchData()
    }
    
    private func setupCartButton() {
        let cartButton = UIBarButtonItem(title: "Cart", style: .plain, target: self, action: #selector(cartButtonTapped))
        navigationItem.rightBarButtonItem = cartButton
    }

    @objc private func cartButtonTapped() {
        let cartVC = CartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    private func fetchData() {
        guard !isLoading else { return }
        isLoading = true
        viewModel.fetchData { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.collectionView.reloadData()
                self?.refreshControl?.endRefreshing()
                if case let .failure(error) = result {
                    print("Error fetching images: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! FeedCell
        let item = viewModel.item(at: indexPath.item)
        cell.viewModel = FeedCellViewModel(imageItem: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath.item)
        let detailVC = DetailViewController()
        let detailViewModel = DetailViewModel(item: item)
        detailVC.viewModel = detailViewModel
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width - 40) / 2 // Calculate item width for 2 columns
        let itemHeight = itemWidth * 1.25 // Adjust item height as needed
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height - 100 { // 100 is the buffer value
            fetchData()
        }
    }
}
