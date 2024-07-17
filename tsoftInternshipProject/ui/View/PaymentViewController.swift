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
        contentView.addSubview(confirmButton)

        let addressStackView = UIStackView(arrangedSubviews: [
            addressLabel,
            cityTextField,
            districtTextField,
            neighborhoodTextField,
            addressTextView,
            addressDescriptionTextView
        ])
        addressStackView.axis = .vertical
        addressStackView.spacing = 8
        addressStackView.translatesAutoresizingMaskIntoConstraints = false

        let paymentStackView = UIStackView(arrangedSubviews: [
            paymentLabel,
            cardholderNameTextField,
            cardNumberTextField,
            expiryMonthYearStackView(),
            cvcTextField
        ])
        paymentStackView.axis = .vertical
        paymentStackView.spacing = 8
        paymentStackView.translatesAutoresizingMaskIntoConstraints = false

        let mainStackView = UIStackView(arrangedSubviews: [
            addressStackView,
            paymentStackView,
            confirmButton
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStackView)

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

    @objc private func confirmButtonTapped() {
        CartViewModel.shared.clearCart()
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
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

        var aRect = self.view.frame
        aRect.size.height -= keyboardFrame.height
        if let activeField = view.findFirstResponder() as? UIView {
            if !aRect.contains(activeField.frame.origin) {
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
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

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createTextField(placeholder: String, keyboardType: UIKeyboardType = .default) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }

    private func createTextView(placeholder: String) -> UITextView {
        let textView = UITextView()
        textView.text = placeholder
        textView.textColor = .lightGray
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }

    private func expiryMonthYearStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [expiryMonthTextField, expiryYearTextField])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }
}

extension PaymentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle max lengths for specific fields
        if textField == cardNumberTextField {
            let maxLength = 16
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == cvcTextField {
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == expiryMonthTextField || textField == expiryYearTextField {
            let maxLength = 2
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}

extension PaymentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textView == addressTextView ? "Address Details" : "Address Description (Optional)"
            textView.textColor = .placeholderText
        }
        updateViewModelForTextView(textView)
    }

    private func updateViewModelForTextView(_ textView: UITextView) {
        if textView == addressTextView {
            viewModel.address = textView.text == "Address Details" ? "" : textView.text
        } else if textView == addressDescriptionTextView {
            viewModel.addressDescription = textView.text == "Address Description (Optional)" ? "" : textView.text
        }
        updateConfirmButtonState()
    }
}

extension UIView {
    func findFirstResponder() -> UIResponder? {
        if self.isFirstResponder {
            return self
        }
        for subview in self.subviews {
            if let firstResponder = subview.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}
