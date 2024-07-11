//
//  NetworkFunctions.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 9.07.2024.
//

import Foundation

class NetworkFunctions {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func fetchImages(query: String? = nil, completion: @escaping ([ImageItem]) -> Void) {
        networkManager.fetchImages(query: query) { result in
            switch result {
            case .success(let items):
                completion(items)
            case .failure(let error):
                print("Error fetching images: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    
}
