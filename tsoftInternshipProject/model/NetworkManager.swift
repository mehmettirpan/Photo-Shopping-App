//
//  NetworkManager.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 4.07.2024.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = APIKEY
    private let baseURL = "https://pixabay.com/api/"

    func fetchImages(query: String? = nil, page: Int = 1, completion: @escaping (Result<[ImageItem], Error>) -> Void) {
        var url = "\(baseURL)?key=\(apiKey)&page=\(page)"
        if let query = query {
            url += "&q=\(query)"
        }

        AF.request(url).responseDecodable(of: PixabayResponse.self) { response in
            switch response.result {
            case .success(let pixabayResponse):
                completion(.success(pixabayResponse.hits))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
