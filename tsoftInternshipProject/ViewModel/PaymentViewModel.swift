//
//  PaymentViewModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 17.07.2024.
//

// PaymentViewModel.swift
import Foundation

class PaymentViewModel {
    var city: String = ""
    var district: String = ""
    var neighborhood: String = ""
    var address: String = ""
    var addressDescription: String = ""
    var cardholderName: String = ""
    var cardNumber: String = ""
    var expiryMonth: String = ""
    var expiryYear: String = ""
    var cvc: String = ""
    
    var isFormValid: Bool {
        return ![
            city,
            district,
            neighborhood,
            cardholderName,
            cardNumber,
            expiryMonth,
            expiryYear,
            cvc,
            address == "Address" ? "" : address
        ].contains(where: { $0.isEmpty }) && isExpiryDateValid() && isCardNumberValid()
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
    
    private func isCardNumberValid() -> Bool {
            return cardNumber.count == 16 && cardNumber.allSatisfy({ $0.isNumber })
        }
}
