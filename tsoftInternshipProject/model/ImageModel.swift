//
//  ImageModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 4.07.2024.
//

import Foundation

struct PixabayResponse: Decodable {
    let hits: [ImageItem]
}

struct ImageItem: Decodable {
    let id: Int
    let previewURL: String
    let previewWidth: Int
    let previewHeight: Int
    let likes: Int
    let comments: Int
    let views: Int
    let webformatURL: String
    let userImageURL: String
    let user: String
    var isFavorite: Bool = false // Favori durumu

    enum CodingKeys: String, CodingKey {
        case previewURL, previewWidth, previewHeight, likes, comments, views, webformatURL, user, userImageURL, id
    }
}

