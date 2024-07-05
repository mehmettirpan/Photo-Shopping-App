//
//  NetworkManager.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 4.07.2024.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = APIKEY // API anahtarını saklamak için özel bir alan.
    private let baseURL = "https://pixabay.com/api/" // Pixabay API'sinin temel URL'i.

    // İmajları getiren fonksiyon.
    func fetchImages(query: String? = nil, completion: @escaping (Result<[ImageItem], Error>) -> Void) {
        var url = "\(baseURL)?key=\(apiKey)" // Temel URL'e API anahtarı eklenmiş URL.

        // Eğer bir sorgu varsa, URL'e sorguyu ekler.
        if let query = query {
            url += "&q=\(query)"
        }

        // Alamofire ile URL'ye istek gönderilir, ve gelen cevap dekodable olarak PixabayResponse tipine çevrilir.
        AF.request(url).responseDecodable(of: PixabayResponse.self) { response in
            switch response.result {
            case .success(let pixabayResponse):
                completion(.success(pixabayResponse.hits)) // Başarılı olursa, gelen görüntü öğelerini success case'i içinde döndürür.
            case .failure(let error):
                completion(.failure(error)) // Başarısız olursa, hata durumunu failure case'i içinde döndürür.
            }
        }
    }
}
