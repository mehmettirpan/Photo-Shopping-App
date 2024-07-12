//
//  SearchListViewModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 9.07.2024.
//

import Foundation

class SearchViewModel {
    private var items: [ImageItem] = []
    private var currentPage = 1
    private var isFetching = false
    
    func fetchImages(query: String? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !isFetching else { return }
        isFetching = true
        NetworkManager.shared.fetchImages(query: query, page: currentPage) { [weak self] result in
            self?.isFetching = false
            switch result {
            case .success(let newItems):
                self?.items.append(contentsOf: newItems)
                self?.currentPage += 1
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchImages(query: String, completion: @escaping (Result<Void, Error>) -> Void) {
        currentPage = 1 // Reset the page for a new search
        items.removeAll()
        fetchImages(query: query, completion: completion)
    }
    
    func clearItems() {
        items.removeAll()
        currentPage = 1
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> ImageItem {
        return items[index]
    }
}
