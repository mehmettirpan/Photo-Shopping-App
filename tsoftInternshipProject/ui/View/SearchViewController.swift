//
//  SearchListViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 4.07.2024.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    var searchBar: UISearchBar!
    var collectionView: UICollectionView!
    var viewModel: SearchViewModel!
    var refreshControl: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel()
        setupSearchBar()
        setupCollectionView()
        fetchImages()
        setupRefreshControl()
    }

    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: "SearchScreenImageCell")
        collectionView.backgroundColor = .systemBackground
        self.view.addSubview(collectionView)
    }

    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc func handleRefresh(_ sender: Any) {
        fetchImages()
    }

    func fetchImages() {
        viewModel.fetchImages { [weak self] result in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.refreshControl?.endRefreshing()
                if case let .failure(error) = result {
                    print("Error fetching images: \(error.localizedDescription)")
                }
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text, !query.isEmpty else {
            viewModel.clearItems()
            fetchImages()
            return
        }

        viewModel.searchImages(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchScreenImageCell", for: indexPath) as! SearchCell
        let item = viewModel.item(at: indexPath.item)
        cell.configure(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = viewModel.item(at: indexPath.item)
        let width: CGFloat = (collectionView.frame.width - 30) / 3 // 3 sütunlu düzen için
        let height = width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath.item)
        let detailVC = DetailViewController()
        let detailViewModel = DetailViewModel(item: item)
        detailVC.viewModel = detailViewModel
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height - 100 { // 100 is the buffer value
            fetchImages()
        }
    }
}
