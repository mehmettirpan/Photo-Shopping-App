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
    private var currentQuery: String?

    func fetchImages(query: String? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !isFetching else { return }
        isFetching = true
        
        if let query = query {
            // If a new query is provided, reset the current query and page
            if currentQuery != query {
                currentQuery = query
                currentPage = 1
                items.removeAll()
            }
        }
        
        NetworkManager.shared.fetchImages(query: currentQuery, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            switch result {
            case .success(let newItems):
                self.items.append(contentsOf: newItems)
                self.currentPage += 1
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchImages(query: String, completion: @escaping (Result<Void, Error>) -> Void) {
        currentQuery = query
        currentPage = 1 // Reset the page for a new search
        items.removeAll()
        fetchImages(query: query, completion: completion)
    }
    
    func clearItems() {
        items.removeAll()
        currentPage = 1
        currentQuery = nil
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> ImageItem {
        return items[index]
    }
    
    func resetData() {
        items.removeAll()
        currentPage = 1
        currentQuery = nil
    }
}
