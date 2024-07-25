//
//  SavedAddressDetailViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 22.07.2024.
//

import UIKit
import CoreData

class SavedAddressDetailViewController: UIViewController {
    var isNewAddress = false
    var address: SavedAddress?
    
    private let addressTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupUI()
        configureView()
    }
    
    private func setupUI() {
        addressTextField.borderStyle = .roundedRect
        addressTextField.placeholder = "Enter Address"
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [addressTextField, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureView() {
        if let address = address {
            addressTextField.text = address.addressDetails
        }
    }
    
    @objc private func saveButtonTapped() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if isNewAddress {
            let newAddress = SavedAddress(context: context)
            newAddress.addressDetails = addressTextField.text
        } else {
            address?.addressDetails = addressTextField.text
        }
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save address: \(error)")
        }
    }
}
