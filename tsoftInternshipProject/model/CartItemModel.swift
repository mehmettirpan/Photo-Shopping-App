//
//  CartItemModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 14.07.2024.
//

import UIKit

struct CartItem: Codable {
    let id: Int
    let image: UIImage
    let price: Double
    var quantity: Int
    

    private enum CodingKeys: String, CodingKey {
        case id, image, price, quantity
    }

    // Custom encoding to handle UIImage
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        if let imageData = image.pngData() {
            try container.encode(imageData, forKey: .image)
        }
        try container.encode(price, forKey: .price)
        try container.encode(quantity, forKey: .quantity)
    }

    // Custom decoding to handle UIImage
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        let imageData = try container.decode(Data.self, forKey: .image)
        image = UIImage(data: imageData) ?? UIImage()
        price = try container.decode(Double.self, forKey: .price)
        quantity = try container.decode(Int.self, forKey: .quantity)
    }

    init(id: Int, image: UIImage, price: Double, quantity: Int) {
        self.id = id
        self.image = image
        self.price = price
        self.quantity = quantity
    }
}
