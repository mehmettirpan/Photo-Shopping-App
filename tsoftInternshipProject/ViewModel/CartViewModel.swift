//
//  CartViewModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 10.07.2024.
//

import Foundation

class CartViewModel {
    private(set) var cartItems: [CartItem] = []

    func addItem(_ item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.image == item.image }) {
            cartItems[index].quantity += 1
        } else {
            var newItem = item
            newItem.quantity = 1
            cartItems.append(newItem)
        }
    }

    func removeItem(at index: Int) {
        cartItems.remove(at: index)
    }

    func updateQuantity(at index: Int, quantity: Int) {
        cartItems[index].quantity = quantity
        if cartItems[index].quantity == 0 {
            removeItem(at: index)
        }
    }

    func totalPrice() -> Double {
        return cartItems.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
}
