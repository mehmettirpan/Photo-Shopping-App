//
//  PaymentViewModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 17.07.2024.
//

import Foundation
import CoreData
import UIKit

class PaymentViewModel {
    
    private var orders: [Order] = []
    
    var city: String = "" {
        didSet { validateForm() }
    }
    
    var district: String = "" {
        didSet { validateForm() }
    }
    
    var neighborhood: String = "" {
        didSet { validateForm() }
    }
    
    var addressDetails: String = "" {
        didSet { validateForm() }
    }
    
    var addressDescription: String = "" {
        didSet { validateForm() }
    }
    
    var cardholderName: String = "" {
        didSet { validateForm() }
    }
    
    var cardNumber: String = "" {
        didSet { validateForm() }
    }
    
    var expiryMonth: String = "" {
        didSet { validateForm() }
    }
    
    var expiryYear: String = "" {
        didSet { validateForm() }
    }
    
    var cvc: String = "" {
        didSet { validateForm() }
    }
    
    var isFormValid: Bool = false
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var addressSwitchOn: Bool = false
    var cardSwitchOn: Bool = false
    
    private func validateForm() {
        let isAddressValid = !city.isEmpty && !district.isEmpty && !neighborhood.isEmpty && !addressDetails.isEmpty
        let isPaymentValid = !cardholderName.isEmpty && cardNumber.count == 16 && !expiryMonth.isEmpty && !expiryYear.isEmpty && cvc.count == 3
        
        isFormValid = isAddressValid && isPaymentValid && isExpiryDateValid()
    }
    
    func confirmOrder() {
        if addressSwitchOn {
            saveAddress()
        }
        if cardSwitchOn {
            saveCard()
        }
        // Create and save order
        saveOrder()
        // Clear form
        clearForm()
    }
    
    private func saveAddress() {
        let savedAddress = SavedAddress(context: context)
        savedAddress.city = city
        savedAddress.district = district
        savedAddress.neighborhood = neighborhood
        savedAddress.addressDetails = addressDetails
        savedAddress.addressDescription = addressDescription
        do {
            try context.save()
        } catch {
            print("Failed to save address: \(error)")
        }
    }
    
    private func saveCard() {
        let savedCard = Card(context: context)
        savedCard.cardholderName = cardholderName
        savedCard.cardNumber = cardNumber
        savedCard.expiryMonth = expiryMonth
        savedCard.expiryYear = expiryYear
        savedCard.cvc = cvc
        do {
            try context.save()
        } catch {
            print("Failed to save card: \(error)")
        }
    }
    
    private func saveOrder() {
        let order = Order(context: context)
        // Ürün bilgilerini kaydet
        let productsString = CartViewModel.shared.cartItems.map { $0.tags }.joined(separator: " - ")
        order.productNames = productsString
        // Adres bilgilerini kaydet
        order.address = "\(city), \(district), \(neighborhood), \(addressDetails)"
        // Kart bilgilerini kaydet
        let maskedCardNumber = String(cardNumber.suffix(4))
        order.cardInfo = "\(cardholderName),  ****\(maskedCardNumber)"
        // Toplam fiyatı kaydet
        order.totalAmount = CartViewModel.shared.totalPrice()
        // Eklenme tarihini kaydet
        order.addedDate = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed to save order: \(error)")
        }
        // Sepeti sıfırla
        CartViewModel.shared.clearCart()
    }
    
    private func clearForm() {
        city = ""
        district = ""
        neighborhood = ""
        addressDetails = ""
        addressDescription = ""
        cardholderName = ""
        cardNumber = ""
        expiryMonth = ""
        expiryYear = ""
        cvc = ""
    }
    
    private func isExpiryDateValid() -> Bool {
        guard let month = Int(expiryMonth), let year = Int(expiryYear) else {
            return false
        }

        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate) % 100
        let currentMonth = calendar.component(.month, from: currentDate)

        if year < currentYear || (year == currentYear && month <= currentMonth) {
            return false
        }

        return month >= 1 && month <= 12
    }
    
    func reset() {
        clearForm()
        addressSwitchOn = false
        cardSwitchOn = false
        isFormValid = false
    }
    
    // Yeni fonksiyonlar
    func useSavedCard(_ card: Card) {
        cardholderName = card.cardholderName ?? ""
        cardNumber = card.cardNumber ?? ""
        expiryMonth = card.expiryMonth ?? ""
        expiryYear = card.expiryYear ?? ""
        cvc = card.cvc ?? ""
        validateForm()
    }
    
    func useSavedAddress(_ address: SavedAddress) {
        city = address.city ?? ""
        district = address.district ?? ""
        neighborhood = address.neighborhood ?? ""
        addressDetails = address.addressDetails ?? ""
        addressDescription = address.addressDescription ?? ""
        validateForm()
    }
}
