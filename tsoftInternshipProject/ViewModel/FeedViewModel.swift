//
//  ListViewModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 9.07.2024.
//

class FeedViewModel {
    private var items: [ImageItem] = []
    private var currentPage = 1
    private var isFetching = false
    
    func fetchData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard !isFetching else { return }
        isFetching = true
        NetworkManager.shared.fetchImages(page: currentPage) { [weak self] result in
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
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> ImageItem {
        return items[index]
    }
}
