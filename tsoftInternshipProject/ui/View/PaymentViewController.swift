//
//  PaymentViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 17.07.2024.
//

import UIKit

class PaymentViewController: UIViewController {
    
    private var viewModel = PaymentViewModel()
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var cityTextField: UITextField!
    private var districtTextField: UITextField!
    private var neighborhoodTextField: UITextField!
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
    
    // New Buttons
    private var savedAddressesButton: UIButton!
    private var savedCardsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        updateConfirmButtonState()
        setupKeyboardObservers()
        setupTapGesture()
        
        addressTextView.text = "Address Details"
        addressTextView.textColor = .placeholderText
        
        addressDescriptionTextView.text = "Address Description (Optional)"
        addressDescriptionTextView.textColor = .placeholderText
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        let addressLabel = createLabel(text: "Address")
        let paymentLabel = createLabel(text: "Payment")

        cityTextField = createTextField(placeholder: "City")
        districtTextField = createTextField(placeholder: "District")
        neighborhoodTextField = createTextField(placeholder: "Neighborhood")
        addressTextView = createTextView(placeholder: "Address Details")
        addressDescriptionTextView = createTextView(placeholder: "Address Description (Optional)")
        cardholderNameTextField = createTextField(placeholder: "Cardholder Name")
        cardNumberTextField = createTextField(placeholder: "Card Number (16 digits)", keyboardType: .numberPad)
        cardNumberTextField.delegate = self
        expiryMonthTextField = createTextField(placeholder: "MM", keyboardType: .numberPad)
        expiryMonthTextField.delegate = self
        expiryYearTextField = createTextField(placeholder: "YY", keyboardType: .numberPad)
        expiryYearTextField.delegate = self
        cvcTextField = createTextField(placeholder: "CVC (3 digits)", keyboardType: .numberPad)
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
        
        // New Buttons Initialization
        savedAddressesButton = createButton(title: "Use Saved Address", action: #selector(useSavedAddress))
        savedCardsButton = createButton(title: "Use Saved Card", action: #selector(useSavedCard))

        // Create address stack view with vertical axis
        let addressStackView = UIStackView(arrangedSubviews: [
            addressLabel,
            cityTextField,
            districtTextField,
            neighborhoodTextField,
            addressTextView,
            addressDescriptionTextView,
            createLabelWithSwitch(text: "Save Address", switchControl: saveAddressSwitch),
            savedAddressesButton // Add the button here
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
            createLabelWithSwitch(text: "Save Card", switchControl: saveCardSwitch),
            savedCardsButton // Add the button here
        ])
        paymentStackView.axis = .vertical
        paymentStackView.spacing = 8
        paymentStackView.translatesAutoresizingMaskIntoConstraints = false

        // Create main stack view
        let mainStackView = UIStackView(arrangedSubviews: [
            addressStackView,
            paymentStackView,
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

    @objc private func saveAddressSwitchChanged(_ sender: UISwitch) {
        viewModel.addressSwitchOn = sender.isOn
    }

    @objc private func saveCardSwitchChanged(_ sender: UISwitch) {
        viewModel.cardSwitchOn = sender.isOn
    }

    @objc private func useSavedAddress() {
        let savedAddressesVC = SavedAddressesViewController()
        savedAddressesVC.delegate = self
        navigationController?.pushViewController(savedAddressesVC, animated: true)
    }

    @objc private func useSavedCard() {
        let savedCardsVC = SavedCardsViewController()
        savedCardsVC.delegate = self
        navigationController?.pushViewController(savedCardsVC, animated: true)
    }

    private func setupBindings() {
        // Bindings from ViewModel to UI (for simplicity, we use target-action approach here)
        cityTextField.addTarget(self, action: #selector(updateViewModel(_:)), for: .editingChanged)
        districtTextField.addTarget(self, action: #selector(updateViewModel(_:)), for: .editingChanged)
        neighborhoodTextField.addTarget(self, action: #selector(updateViewModel(_:)), for: .editingChanged)
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

    @objc private func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case cardNumberTextField:
            if let text = textField.text, text.count > 16 {
                textField.text = String(text.prefix(16))
            }
        case expiryMonthTextField:
            if let text = textField.text, text.count > 2 {
                textField.text = String(text.prefix(2))
            }
        case expiryYearTextField:
            if let text = textField.text, text.count > 2 {
                textField.text = String(text.prefix(2))
            }
        case cvcTextField:
            if let text = textField.text, text.count > 3 {
                textField.text = String(text.prefix(3))
            }
        default:
            break
        }
        updateConfirmButtonState()
    }

    private func createTextField(placeholder: String, keyboardType: UIKeyboardType = .default) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = keyboardType
        return textField
    }

    private func createTextView(placeholder: String) -> UITextView {
        let textView = UITextView()
        textView.text = placeholder
        textView.textColor = .placeholderText
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createLabelWithSwitch(text: String, switchControl: UISwitch) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [label, switchControl])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func expiryMonthYearStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [expiryMonthTextField, expiryYearTextField])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    private func updateConfirmButtonState() {
        confirmButton.isEnabled = viewModel.isFormValid
        confirmButton.backgroundColor = confirmButton.isEnabled ? .systemBlue : .systemGray
    }

    @objc private func confirmButtonTapped() {
        if viewModel.isFormValid {
            // Perform the confirm action here
            // Example: show a confirmation alert
            let alert = UIAlertController(title: "Confirmation", message: "Payment confirmed!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)

            // Reset the form fields
            cityTextField.text = ""
            districtTextField.text = ""
            neighborhoodTextField.text = ""
            addressTextView.text = "Address Details"
            addressTextView.textColor = .placeholderText
            addressDescriptionTextView.text = "Address Description (Optional)"
            addressDescriptionTextView.textColor = .placeholderText
            cardholderNameTextField.text = ""
            cardNumberTextField.text = ""
            expiryMonthTextField.text = ""
            expiryYearTextField.text = ""
            cvcTextField.text = ""
            saveAddressSwitch.isOn = false
            saveCardSwitch.isOn = false
            viewModel.reset()
            updateConfirmButtonState()
        } else {
            // Show an error alert if the form is not valid
            let alert = UIAlertController(title: "Error", message: "Please fill in all required fields correctly.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Keyboard Handling

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension PaymentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            switch textField {
            case cardNumberTextField:
                return updatedText.count <= 16
            case expiryMonthTextField, expiryYearTextField:
                return updatedText.count <= 2
            case cvcTextField:
                return updatedText.count <= 3
            default:
                break
            }
        }
        return true
    }
}

extension PaymentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == addressTextView {
            viewModel.addressDetails = textView.text
        } else if textView == addressDescriptionTextView {
            viewModel.addressDescription = textView.text
        }
        updateConfirmButtonState()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == addressTextView && textView.text == "Address Details" {
            textView.text = ""
            textView.textColor = .label
        } else if textView == addressDescriptionTextView && textView.text == "Address Description (Optional)" {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == addressTextView && textView.text.isEmpty {
            textView.text = "Address Details"
            textView.textColor = .placeholderText
        } else if textView == addressDescriptionTextView && textView.text.isEmpty {
            textView.text = "Address Description (Optional)"
            textView.textColor = .placeholderText
        }
    }
}

extension PaymentViewController: SavedAddressesViewControllerDelegate {
    func didSelectAddress(_ address: SavedAddress) {
        cityTextField.text = address.city
        districtTextField.text = address.district
        neighborhoodTextField.text = address.street
        addressTextView.text = address.addressDetails
        addressTextView.textColor = .label
        addressDescriptionTextView.textColor = .label
    }
    
    
}

extension PaymentViewController: SavedCardsViewControllerDelegate {
    func didSelectCard(_ card: Card) {
        cardholderNameTextField.text = card.cardholderName
        cardNumberTextField.text = card.cardNumber
        expiryMonthTextField.text = card.expiryMonth
        expiryYearTextField.text = card.expiryYear
        cvcTextField.text = card.cvc
    }
}
