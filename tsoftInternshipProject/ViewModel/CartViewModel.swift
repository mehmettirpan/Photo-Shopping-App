//
//  AddToCartViewModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 9.07.2024.
//

import Foundation

class CartViewModel {
    static let shared = CartViewModel()
    private let cartKey = "cartItems"

    // Notification name for cart changes
    static let cartChangedNotification = Notification.Name("CartChangedNotification")
    
    private init() {
        loadCartItems()
    }

    private var items: [CartItem] = []

    var cartItems: [CartItem] {
        return items
    }

    func addItem(_ item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            items[index].quantity += 1
            saveCartItems()
        } else {
            items.append(item)
            saveCartItems()
        }
        notifyCartChanged()

    }
    
    func clearCart() {
        items.removeAll()
        saveCartItems()
        notifyCartChanged()
    }

    func updateQuantity(at index: Int, quantity: Int) {
        guard index >= 0 && index < items.count else {
            print("Error: Index out of bounds for updating quantity")
            return
        }
        items[index].quantity = quantity
        saveCartItems()
        notifyCartChanged()
    }

    func removeItem(at index: Int) {
        guard index >= 0 && index < items.count else {
            print("Error: Index out of bounds for removing item")
            return
        }
        items.remove(at: index)
        saveCartItems()
        notifyCartChanged()
    }

    func totalPrice() -> Double {
        return items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    private func saveCartItems() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: cartKey)
        }
    }

    private func loadCartItems() {
        if let savedItems = UserDefaults.standard.object(forKey: cartKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedItems = try? decoder.decode([CartItem].self, from: savedItems) {
                items = loadedItems
            }
        }
    }
    
    private func notifyCartChanged() {
        NotificationCenter.default.post(name: CartViewModel.cartChangedNotification, object: nil)
    }
}
