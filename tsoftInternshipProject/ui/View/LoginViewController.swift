//
//  LoginViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 12.07.2024.
//

/*
 Kullanıcı Adı ve Şifre Admin Panelinde
 username: MehmetTırpan
 password: admin
 Diğer kullanıcılar:https://jsonplaceholder.typicode.com/users bu sayfada ve
 username == username , password == email
 */

import UIKit

class LoginViewController: UIViewController {
    
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    var imageView: UIImageView!
    var designedByLabel: UILabel!

    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Arka plan rengi veya görüntüsü ayarlayın
        self.view.backgroundColor = UIColor.systemBackground
        
        // Görseli ekleyin
        imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        // "Designed By Mehmet TIRPAN" etiketini ekleyin
        designedByLabel = UILabel()
        designedByLabel.text = "Designed By Mehmet TIRPAN"
        designedByLabel.textColor = .gray
        designedByLabel.textAlignment = .center
        designedByLabel.font = UIFont.systemFont(ofSize: 14)
        designedByLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(designedByLabel)
        
        // Kullanıcı adı ve şifre alanlarını ekleyin
        usernameTextField = UITextField()
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(usernameTextField)
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(passwordTextField)
        
        // Giriş butonunu ekleyin
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loginButton)
        
        // Auto Layout ayarları
        NSLayoutConstraint.activate([
            // Logo görseli için Auto Layout ayarları
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),  // Görselin genişliği (ekran genişliğinin %60'ı)
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor), // Görselin yüksekliği, genişliğine eşit (kare olması için)
            
            // Username ve Password textfield'leri için Auto Layout ayarları
            usernameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            usernameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            // Login butonu için Auto Layout ayarları
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            // "Designed By Mehmet TIRPAN" etiketi için Auto Layout ayarları
            designedByLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            designedByLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            designedByLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
            
        fetchUsers()
    }

    func fetchUsers() {
        UserNetworkManager.shared.fetchUsers { users in
            if let users = users {
                self.users = users
                print("Fetched \(users.count) users")
                for user in users {
                    print("User: \(user.name) (\(user.username))")
                }
            }
        }
    }

    @objc func loginButtonTapped() {
        
        if usernameTextField.text == "MehmetTırpan" && passwordTextField.text == "admin"{
            showMainScreen()
        }else{
            guard let username = usernameTextField.text, let password = passwordTextField.text else {
                return
            }
            
            var isLoginSuccessful = false
            var loggedInUser: User?
            
            for user in users {
                if user.username == username && password == user.email {
                    print("Login successful for user: \(user.name)")
                    isLoginSuccessful = true
                    loggedInUser = user
                    break
                }
            }
            
            if isLoginSuccessful {
                if let user = loggedInUser {
//                    showWelcome(title: "Login Successful", message: "Welcome, \(user.name)")
                    showMainScreen()
                }
            } else {
                showAlert(title: "Login Failed", message: "Invalid username or password")
            }
        }
    }

    func showMainScreen() {
            // Main storyboard'u yükle
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // Storyboard'dan Tab Bar Controller'ı yükle
            if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
                
                // Geçiş animasyonu
                tabBarController.modalTransitionStyle = .crossDissolve
                tabBarController.modalPresentationStyle = .fullScreen
                self.present(tabBarController, animated: true, completion: nil)
            }
        }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showWelcome(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
