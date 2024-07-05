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
    let previewURL: String
    let previewWidth: Int
    let previewHeight: Int
    let likes: Int
    let comments: Int
    let views: Int
    let webformatURL: String
    let userImageURL: String
    let user: String
}
