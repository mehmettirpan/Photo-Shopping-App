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
    var city: String = "" { didSet { validateForm() }}
    var district: String = "" { didSet { validateForm() }}
    var street: String = "" { didSet { validateForm() }}
    var address: String = "" { didSet { validateForm() }}
    var addressDescription: String = "" { didSet { validateForm() }}
    var neighborhood: String = "" { didSet { validateForm() }}
    var cardholderName: String = "" { didSet { validateForm() }}
    var cardNumber: String = "" { didSet { validateForm() }}
    var expiryMonth: String = "" { didSet { validateForm() }}
    var expiryYear: String = "" { didSet { validateForm() }}
    var cvc: String = "" { didSet { validateForm() }}
    var isFormValid: Bool = false
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var addressSwitchOn: Bool = false
    var cardSwitchOn: Bool = false
    
    private func validateForm() {
        let isAddressValid = !city.isEmpty && !district.isEmpty && !street.isEmpty && !address.isEmpty && !neighborhood.isEmpty
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
    
    private func saveOrder() {
        let order = Order(context: context)
        // Ürün bilgilerini kaydet
        let productsString = CartViewModel.shared.cartItems.map { $0.tags }.joined(separator: " - ")
        order.productNames = productsString
        // Adres bilgilerini kaydet
        order.address = "\(city), \(district), \(neighborhood), \(street), \(address)"
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
    

    
    func createTextField(placeholder: String, keyboardType: UIKeyboardType = .default) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = keyboardType
        return textField
    }

    func createTextView() -> UITextView {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
        textView.textColor = .placeholderText
        textView.font = .systemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }

    func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createDescriptionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func createLabelWithSwitch(text: String, switchControl: UISwitch) -> UIStackView {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [label, switchControl])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }

    
}
