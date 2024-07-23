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
    var city: String = "" {
        didSet { validateForm() }
    }
    
    var district: String = "" {
        didSet { validateForm() }
    }
    
    var street: String = "" {
        didSet { validateForm() }
    }
    
    var address: String = "" {
        didSet { validateForm() }
    }
    
    var addressDescription: String = "" {
        didSet { validateForm() }
    }
    
    var neighborhood: String = "" {
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
        let isAddressValid = !city.isEmpty && !district.isEmpty && !street.isEmpty && !address.isEmpty
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
        
        // Clear form
        clearForm()
    }
    
    private func saveAddress() {
        let savedAddress = SavedAddress(context: context)
        savedAddress.city = city
        savedAddress.district = district
        savedAddress.street = street
        savedAddress.addressDetails = address
        savedAddress.addressDescription = addressDescription
        savedAddress.neighborhood = neighborhood
        do {
            try context.save()
        } catch {
            print("Failed to save address: \(error)")
        }
    }
    
    private func saveCard() {
        let savedCards = Card(context: context)
        savedCards.cardholderName = cardholderName
        savedCards.cardNumber = cardNumber
        savedCards.expiryMonth = expiryMonth
        savedCards.expiryYear = expiryYear
        savedCards.cvc = cvc
        do {
            try context.save()
        } catch {
            print("Failed to save card: \(error)")
        }
    }
    
    private func clearForm() {
        city = ""
        district = ""
        street = ""
        address = ""
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
}
