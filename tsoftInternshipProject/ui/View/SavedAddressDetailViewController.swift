//
//  SavedAddressDetailViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 22.07.2024.
//

import UIKit
import CoreData

class SavedAddressDetailViewController: UIViewController {
    var address: SavedAddress?
    var isNewAddress: Bool = false

    private var isEditingAddress = false
    private let addressTitleTextField = UITextField()
    private let cityTextField = UITextField()
    private let districtTextField = UITextField()
    private let streetTextField = UITextField()
    private let addressDetailsTextField = UITextField()
    private let addressDescriptionTextField = UITextField()
    private let neighborhoodTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Address Details"
        
        setupTextFields()
        setupEditButton()
        displayAddressDetails()
        toggleEditing(enabled: isNewAddress)
    }

    private func setupTextFields() {
        let addressTitleLabel = createLabel(with: "Address Title")
        let cityLabel = createLabel(with: "City")
        let districtLabel = createLabel(with: "District")
        let streetLabel = createLabel(with: "Street")
        let addressDetailsLabel = createLabel(with: "Address Details")
        let addressDescriptionLabel = createLabel(with: "Address Description")
        let neighborhoodLabel = createLabel(with: "Neighborhood")

        styleTextField(addressTitleTextField, placeholder: "Enter address title")
        styleTextField(cityTextField, placeholder: "Enter city")
        styleTextField(districtTextField, placeholder: "Enter district")
        styleTextField(streetTextField, placeholder: "Enter street")
        styleTextField(addressDetailsTextField, placeholder: "Enter address details")
        styleTextField(addressDescriptionTextField, placeholder: "Enter address description")
        styleTextField(neighborhoodTextField, placeholder: "Enter neighborhood")

        let stackView = UIStackView(arrangedSubviews: [
            addressTitleLabel, addressTitleTextField,
            cityLabel, cityTextField,
            districtLabel, districtTextField,
            neighborhoodLabel, neighborhoodTextField,
            streetLabel, streetTextField,
            addressDetailsLabel, addressDetailsTextField,
            addressDescriptionLabel, addressDescriptionTextField
        ])
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

    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }

    private func styleTextField(_ textField: UITextField, placeholder: String) {
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = placeholder
    }

    private func setupEditButton() {
        let editButton = UIBarButtonItem(title: isNewAddress ? "Save" : "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
    }

    private func displayAddressDetails() {
        guard let address = address else {
            isNewAddress = true
            toggleEditing(enabled: true)
            navigationItem.rightBarButtonItem?.title = "Save"
            return
        }
        addressTitleTextField.text = address.addressTitle
        cityTextField.text = address.city
        districtTextField.text = address.district
        streetTextField.text = address.street
        addressDetailsTextField.text = address.addressDetails
        addressDescriptionTextField.text = address.addressDescription
        neighborhoodTextField.text = address.neighborhood
    }

    @objc private func editButtonTapped() {
        isEditingAddress.toggle()
        toggleEditing(enabled: isEditingAddress)
        navigationItem.rightBarButtonItem?.title = isEditingAddress ? "Save" : "Edit"
        
        if !isEditingAddress {
            if isNewAddress {
                saveNewAddress()
            } else {
                saveAddressDetails()
            }
        }
    }

    private func toggleEditing(enabled: Bool) {
        addressTitleTextField.isUserInteractionEnabled = enabled
        cityTextField.isUserInteractionEnabled = enabled
        districtTextField.isUserInteractionEnabled = enabled
        streetTextField.isUserInteractionEnabled = enabled
        addressDetailsTextField.isUserInteractionEnabled = enabled
        addressDescriptionTextField.isUserInteractionEnabled = enabled
        neighborhoodTextField.isUserInteractionEnabled = enabled
    }

    private func saveNewAddress() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }

        let newAddress = SavedAddress(context: context)
        newAddress.addressTitle = addressTitleTextField.text
        newAddress.city = cityTextField.text
        newAddress.district = districtTextField.text
        newAddress.street = streetTextField.text
        newAddress.addressDetails = addressDetailsTextField.text
        newAddress.addressDescription = addressDescriptionTextField.text
        newAddress.neighborhood = neighborhoodTextField.text
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save address: \(error)")
        }
    }

    private func saveAddressDetails() {
        guard let address = address else { return }
        
        address.addressTitle = addressTitleTextField.text
        address.city = cityTextField.text
        address.district = districtTextField.text
        address.street = streetTextField.text
        address.addressDetails = addressDetailsTextField.text
        address.addressDescription = addressDescriptionTextField.text
        address.neighborhood = neighborhoodTextField.text
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save address: \(error)")
        }
    }
}
