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
    var loginButton: UIButton!
    
    var loginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoginStatus()
        self.view.backgroundColor = UIColor.systemBackground
        
        imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        designedByLabel = UILabel()
        designedByLabel.text = "Designed By Mehmet TIRPAN"
        designedByLabel.textColor = .gray
        designedByLabel.textAlignment = .center
        designedByLabel.font = UIFont.systemFont(ofSize: 14)
        designedByLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(designedByLabel)
        
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
        
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .systemGreen
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            usernameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            usernameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            designedByLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            designedByLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            designedByLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    @objc func loginButtonTapped() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }

        if username == loginViewModel.adminUser.username && password == "admin" {
            loginViewModel.saveUserToUserDefaults(user: loginViewModel.adminUser)
            showWelcome(title: "Hoş Geldin Patron", message: "")
            showMainScreen(user: loginViewModel.adminUser)
        } else {
            var isLoginSuccessful = false
            var loggedInUser: User?

            for user in loginViewModel.users {
                if user.username == username && password == user.email {
                    print("Login successful for user: \(user.name)")
                    isLoginSuccessful = true
                    loggedInUser = user
                    break
                }
            }

            if isLoginSuccessful {
                if let user = loggedInUser {
                    loginViewModel.saveUserToUserDefaults(user: user)
                    showWelcome(title: "Login Successful", message: "Welcome, \(user.name)")
                    showMainScreen(user: user)
                }
            } else {
                showAlert(title: "Login Failed", message: "Invalid username or password")
            }
        }
    }

    func checkLoginStatus() {
        if let savedUser = loginViewModel.getUserFromUserDefaults() {
            showMainScreen(user: savedUser)
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showWelcome(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                alert.dismiss(animated: true, completion: {
                    if let user = self.loginViewModel.users.first(where: { $0.username == self.usernameTextField.text }) {
                        self.showMainScreen(user: user)
                    } else {
                        self.showMainScreen()
                    }
                })
            }
        }
    }

    func showMainScreen(user: User? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
            tabBarController.modalTransitionStyle = .crossDissolve
            tabBarController.modalPresentationStyle = .fullScreen

            if let profileVC = tabBarController.viewControllers?.first(where: { $0 is ProfileViewController }) as? ProfileViewController {
                profileVC.user = user
            }

            self.present(tabBarController, animated: true, completion: nil)
        }
    }
}
