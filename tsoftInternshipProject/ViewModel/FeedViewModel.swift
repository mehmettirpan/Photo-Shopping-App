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
    
//    Bu özellik bazı çökmelere yol açabiliyor search ve feed ekranında kontrol etmek gerekiyor, handlereflesh de kullandım, bazı istenmeyecek çökmelere yol açabiliyor
    /*
     Bunu düzeltmek için currentpage ve gelen veriler biraz daha ayarlanmalı,
     zaman olduğunda bakılıp yapılabilecek bir fonksiyon, yapılsa daha güzel olur
     */
//    func resetData() {
//        items.removeAll()
//    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> ImageItem {
        return items[index]
    }
}
