//
//  PaymentViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 17.07.2024.
//

import UIKit

class PaymentViewController: UIViewController {
//    MARK: Properties
    private var viewModel = PaymentViewModel()
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var cityTextField: UITextField!
    private var districtTextField: UITextField!
    private var neighborhoodTextField: UITextField!
    private var streetTextField: UITextField!
    private var addressTextView: UITextView!
    private var addressDescriptionTextView: UITextView!
    private var cardholderNameTextField: UITextField!
    private var cardNumberTextField: UITextField!
    private var expiryMonthTextField: UITextField!
    private var expiryYearTextField: UITextField!
    private var cvcTextField: UITextField!
    private var confirmButton: UIButton!
    private var saveAddressSwitch: UISwitch!
    private var saveCardSwitch: UISwitch!
    private let addressTitleTextField = UITextField()
    private var cartViewModel = CartViewModel.shared
    private var savedAddressButton: UIButton!
    private var savedCardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payment"
        
        setupUI()
        setupBindings()
        updateConfirmButtonState()
        setupKeyboardObservers()
        setupTapGesture()
    }
    
//  MARK: SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        let addressLabel = viewModel.createTitleLabel(text: "Address")
        let paymentLabel = viewModel.createTitleLabel(text: "Credit Card")
        
        let addressDetailLabel = viewModel.createDescriptionLabel(text: "Enter your addresses detail")
        let addressDescriptionLabel = viewModel.createDescriptionLabel(text: "Enter your address description (Optional)")

        cityTextField = viewModel.createTextField(placeholder: "City")
        districtTextField = viewModel.createTextField(placeholder: "District")
        neighborhoodTextField = viewModel.createTextField(placeholder: "Neighborhood")
        streetTextField = viewModel.createTextField(placeholder: "Street")
        addressTextView = viewModel.createTextView()
        addressDescriptionTextView = viewModel.createTextView()
        cardholderNameTextField = viewModel.createTextField(placeholder: "Cardholder Name")
        cardNumberTextField = viewModel.createTextField(placeholder: "Card Number (16 digits)", keyboardType: .numberPad)
        cardNumberTextField.delegate = self
        expiryMonthTextField = viewModel.createTextField(placeholder: "MM", keyboardType: .numberPad)
        expiryMonthTextField.delegate = self
        expiryYearTextField = viewModel.createTextField(placeholder: "YY", keyboardType: .numberPad)
        expiryYearTextField.delegate = self
        cvcTextField = viewModel.createTextField(placeholder: "CVC (3 digits)", keyboardType: .numberPad)
        cvcTextField.isSecureTextEntry = true
        cvcTextField.delegate = self

        confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .systemGray
        confirmButton.layer.cornerRadius = 8
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.isEnabled = false
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)

        saveAddressSwitch = UISwitch()
        saveAddressSwitch.translatesAutoresizingMaskIntoConstraints = false
        saveAddressSwitch.addTarget(self, action: #selector(saveAddressSwitchChanged), for: .valueChanged)

        saveCardSwitch = UISwitch()
        saveCardSwitch.translatesAutoresizingMaskIntoConstraints = false
        saveCardSwitch.addTarget(self, action: #selector(saveCardSwitchChanged), for: .valueChanged)
        
        // Saved Address Button
        savedAddressButton = UIButton(type: .system)
        savedAddressButton.setTitle("Use Saved Address", for: .normal)
        savedAddressButton.addTarget(self, action: #selector(savedAddressButtonTapped), for: .touchUpInside)
        savedAddressButton.translatesAutoresizingMaskIntoConstraints = false

        // Saved Card Button
        savedCardButton = UIButton(type: .system)
        savedCardButton.setTitle("Use Saved Card", for: .normal)
        savedCardButton.addTarget(self, action: #selector(savedCardButtonTapped), for: .touchUpInside)
        savedCardButton.translatesAutoresizingMaskIntoConstraints = false


        // Create address stack view with vertical axis
        let addressStackView = UIStackView(arrangedSubviews: [
            addressLabel,
            cityTextField,
            districtTextField,
            neighborhoodTextField,
            streetTextField,
            addressDetailLabel,
            addressTextView,
            addressDescriptionLabel,
            addressDescriptionTextView,
            viewModel.createLabelWithSwitch(text: "Save Address", switchControl: saveAddressSwitch)
        ])
        addressStackView.axis = .vertical
        addressStackView.spacing = 8
        addressStackView.translatesAutoresizingMaskIntoConstraints = false

        // Create payment stack view
        let paymentStackView = UIStackView(arrangedSubviews: [
            paymentLabel,
            cardholderNameTextField,
            cardNumberTextField,
            expiryMonthYearStackView(),
            cvcTextField,
            viewModel.createLabelWithSwitch(text: "Save Card", switchControl: saveCardSwitch)
        ])
        paymentStackView.axis = .vertical
        paymentStackView.spacing = 8
        paymentStackView.translatesAutoresizingMaskIntoConstraints = false

        // Add buttons to main stack view
        let mainStackView = UIStackView(arrangedSubviews: [
            addressStackView,
            savedAddressButton,
            paymentStackView,
            savedCardButton,
            confirmButton
        ])
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStackView)

        // Set constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            addressTextView.heightAnchor.constraint(equalToConstant: 100),
            addressDescriptionTextView.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        [cityTextField, districtTextField, neighborhoodTextField, cardholderNameTextField, cardNumberTextField, expiryMonthTextField, expiryYearTextField, cvcTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }

        addressTextView.delegate = self
        addressDescriptionTextView.delegate = self
    }

//  MARK: UI Functions

    private func setupBindings() {
        // Bindings from ViewModel to UI (for simplicity, we use target-action approach here)
        cityTextField.addTarget(self, action: #selector(updateViewModel(_:)), for: .editingChanged)
        districtTextField.addTarget(self, action: #selector(updateViewModel(_:)), for: .editingChanged)
        neighborhoodTextField.addTarget(self, action: #selector(updateViewModel(_:)), for: .editingChanged)
        streetTextField.addTarget(self, action: #selector(updateViewModel(_:)), for: .editingChanged)
        addressTextView.delegate = self
        addressDescriptionTextView.delegate = self
        cardholderNameTextField.addTarget(self, action: #selector(updateViewModel(_:)), for: .editingChanged)
        cardNumberTextField.addTarget(self, action: #selector(updateViewModel(_:)), for: .editingChanged)
        expiryMonthTextField.addTarget(self, action: #selector(updateViewModel(_:)), for: .editingChanged)
        expiryYearTextField.addTarget(self, action: #selector(updateViewModel(_:)), for: .editingChanged)
        cvcTextField.addTarget(self, action: #selector(updateViewModel(_:)), for: .editingChanged)
    }

    @objc private func updateViewModel(_ textField: UITextField) {
        switch textField {
        case cityTextField:
            viewModel.city = textField.text ?? ""
        case districtTextField:
            viewModel.district = textField.text ?? ""
        case neighborhoodTextField:
            viewModel.neighborhood = textField.text ?? ""
        case streetTextField:
            viewModel.street = textField.text ?? ""
        case cardholderNameTextField:
            viewModel.cardholderName = textField.text ?? ""
        case cardNumberTextField:
            viewModel.cardNumber = textField.text ?? ""
        case expiryMonthTextField:
            viewModel.expiryMonth = textField.text ?? ""
        case expiryYearTextField:
            viewModel.expiryYear = textField.text ?? ""
        case cvcTextField:
            viewModel.cvc = textField.text ?? ""
        default:
            break
        }
        updateConfirmButtonState()
    }

    @objc func saveAddressSwitchChanged(_ sender: UISwitch) {
        viewModel.addressSwitchOn = sender.isOn
    }

    @objc func saveCardSwitchChanged(_ sender: UISwitch) {
        viewModel.cardSwitchOn = sender.isOn
    }
    
    @objc private func confirmButtonTapped() {
        viewModel.confirmOrder()
        navigationController?.popToRootViewController(animated: true)
        cartViewModel.clearCart()
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case cityTextField:
            viewModel.city = textField.text ?? ""
        case districtTextField:
            viewModel.district = textField.text ?? ""
        case neighborhoodTextField:
            viewModel.neighborhood = textField.text ?? ""
        case streetTextField:
            viewModel.street = textField.text ?? ""
        case cardholderNameTextField:
            viewModel.cardholderName = textField.text ?? ""
        case cardNumberTextField:
            viewModel.cardNumber = textField.text ?? ""
        case expiryMonthTextField:
            viewModel.expiryMonth = textField.text ?? ""
        case expiryYearTextField:
            viewModel.expiryYear = textField.text ?? ""
        case cvcTextField:
            viewModel.cvc = textField.text ?? ""
        default:
            break
        }

        // Handle max lengths for specific fields
        if textField == cardNumberTextField && textField.text?.count ?? 0 > 16 {
            textField.text = String(textField.text?.prefix(16) ?? "")
        } else if textField == cvcTextField && textField.text?.count ?? 0 > 3 {
            textField.text = String(textField.text?.prefix(3) ?? "")
        } else if (textField == expiryMonthTextField || textField == expiryYearTextField) && textField.text?.count ?? 0 > 2 {
            textField.text = String(textField.text?.prefix(2) ?? "")
        }

        updateConfirmButtonState()
    }

    private func updateConfirmButtonState() {
        let isFormValid = viewModel.isFormValid
        confirmButton.isEnabled = isFormValid
        confirmButton.backgroundColor = isFormValid ? UIColor(named: "ButtonColor") : .systemGray
    }
    
    @objc private func savedAddressButtonTapped() {
        let savedAddressesVC = SavedAddressesViewController()
        savedAddressesVC.previousScreen = .payment
        savedAddressesVC.delegate = self
        navigationController?.pushViewController(savedAddressesVC, animated: true)
    }

    @objc private func savedCardButtonTapped() {
        let savedCardsVC = SavedCardsViewController()
        savedCardsVC.previousScreen = .payment
        savedCardsVC.delegate = self
        navigationController?.pushViewController(savedCardsVC, animated: true)
    }


    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func expiryMonthYearStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [expiryMonthTextField, expiryYearTextField])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}

    // MARK: - UITextFieldDelegate
    extension PaymentViewController: UITextFieldDelegate {
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let maxLength: Int
            if textField == cardNumberTextField {
                maxLength = 16
            } else if textField == cvcTextField {
                maxLength = 3
            } else if textField == expiryMonthTextField || textField == expiryYearTextField {
                maxLength = 2
            } else {
                maxLength = 100
            }
            
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
    }

    // MARK: - UITextViewDelegate
    extension PaymentViewController: UITextViewDelegate {
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .placeholderText {
                textView.text = nil
                textView.textColor = .label
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
//            if textView.text.isEmpty {
//                textView.text = textView == addressTextView ? "Address Details" : "Address Description (Optional)"
//                textView.textColor = .placeholderText
//            }
            if textView == addressTextView {
                viewModel.address = textView.text
            } else if textView == addressDescriptionTextView {
                viewModel.addressDescription = textView.text
            }
            updateConfirmButtonState()
        }
    }
// MARK: - SavedAddressesVCDelegate

extension PaymentViewController: SavedAddressesViewControllerDelegate {
    func didSelectSavedAddress(_ address: SavedAddress) {
        viewModel.city = address.city ?? ""
        viewModel.district = address.district ?? ""
        viewModel.neighborhood = address.neighborhood ?? ""
        viewModel.street = address.street ?? ""
        viewModel.address = address.addressDetails ?? ""
        viewModel.addressDescription = address.addressDescription ?? ""

        cityTextField.text = address.city
        districtTextField.text = address.district
        neighborhoodTextField.text = address.neighborhood
        streetTextField.text = address.street
        addressTextView.text = address.addressDetails
        addressDescriptionTextView.text = address.addressDescription

        updateConfirmButtonState()
    }
}

// MARK: - SavedCarsVCDelegate

extension PaymentViewController: SavedCardsViewControllerDelegate {
    func didSelectSavedCard(_ card: Card) {
        viewModel.cardholderName = card.cardholderName ?? ""
        viewModel.cardNumber = card.cardNumber ?? ""
        viewModel.expiryMonth = card.expiryMonth ?? ""
        viewModel.expiryYear = card.expiryYear ?? ""
        viewModel.cvc = card.cvc ?? ""

        cardholderNameTextField.text = card.cardholderName
        cardNumberTextField.text = card.cardNumber
        expiryMonthTextField.text = card.expiryMonth
        expiryYearTextField.text = card.expiryYear
        cvcTextField.text = card.cvc

        updateConfirmButtonState()
    }
}
