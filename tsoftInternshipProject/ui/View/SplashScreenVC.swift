//
//  SplashScreenVC.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 5.07.2024.
//

import UIKit

class SplashScreenVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var activityIndicator: UIActivityIndicatorView!
        var imageView: UIImageView!
        var designedByLabel: UILabel!
        
        
        var preferredStatusBarStyle: UIStatusBarStyle {
            return .darkContent
        }
        
        // Arka plan rengi veya görüntüsü ayarlayın
        self.view.backgroundColor = UIColor.systemBackground
        
        // Görseli ekleyin
        imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        // Activity Indicator ekleyin
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)
        
        // "Designed By Mehmet TIRPAN" etiketini ekleyin
        designedByLabel = UILabel()
        designedByLabel.text = "Designed By Mehmet TIRPAN"
        designedByLabel.textColor = .gray
        designedByLabel.textAlignment = .center
        designedByLabel.font = UIFont.systemFont(ofSize: 14)
        designedByLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(designedByLabel)
        
        // Auto Layout ayarları
        NSLayoutConstraint.activate([
            // Logo görseli için Auto Layout ayarları
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),  // Görselin genişliği (ekran genişliğinin %60'ı)
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor), // Görselin yüksekliği, genişliğine eşit (kare olması için)
            
//          // Activity Indicator için Auto Layout ayarları
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            // "Designed By Mehmet TIRPAN" etiketi için Auto Layout ayarları
            designedByLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            designedByLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            designedByLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        activityIndicator.startAnimating()
        
        // Simulate a delay to show the splash screen for a bit
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showMainScreen()
        }
    }
    
    func showMainScreen() {
            // Main storyboard'u yükle
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // Storyboard'dan Tab Bar Controller'ı yükle
            if let tabBarController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {
                
                // Geçiş animasyonu
                tabBarController.modalTransitionStyle = .crossDissolve
                tabBarController.modalPresentationStyle = .fullScreen
                self.present(tabBarController, animated: true, completion: nil)
            }
        }
    
}


