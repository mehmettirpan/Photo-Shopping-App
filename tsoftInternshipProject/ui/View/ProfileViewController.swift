//
//  ProfileViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 12.07.2024.
//

import UIKit
import MapKit

class ProfileViewController: UIViewController {
    
    var user: User? {
        didSet {
            configureView()
        }
    }
    
    var nameLabel: UILabel!
    var scrollView: UIScrollView!
    var contentView: UIView!
    var usernameLabel: UILabel!
    var emailLabel: UILabel!
    var addressLabel: UILabel!
    var phoneLabel: UILabel!
    var websiteLabel: UILabel!
    var companyLabel: UILabel!
    var mapView: MKMapView!
    var logoutButton: UIButton!
    var ordersButton: UIButton!
    var savedAddressesButton: UIButton!
    var savedCardsButton: UIButton!
    var buttonsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemBackground
        
        print(user?.name as Any) // Debug için user'ı yazdır
        
        ordersButton = createButton(title: "My Orders")
        ordersButton.addTarget(self, action: #selector(showOrders), for: .touchUpInside)
        
        savedAddressesButton = createButton(title: "Saved Addresses")
        savedAddressesButton.addTarget(self, action: #selector(showSavedAddresses), for: .touchUpInside)
        savedAddressesButton.titleLabel?.numberOfLines = 2
        savedAddressesButton.titleLabel?.textAlignment = .center
        savedAddressesButton.backgroundColor = UIColor(named: "ButtonColor")
        
        savedCardsButton = createButton(title: "Saved Cards")
        savedCardsButton.addTarget(self, action: #selector(showSavedCards), for: .touchUpInside)
        savedCardsButton.backgroundColor = UIColor(named: "ButtonColor")
        
        ordersButton.backgroundColor = UIColor(named: "ButtonColor")
        
        buttonsStackView = UIStackView(arrangedSubviews: [ordersButton, savedAddressesButton, savedCardsButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 10
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(buttonsStackView)
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)
        
        usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.numberOfLines = 0
        contentView.addSubview(usernameLabel)
        
        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.numberOfLines = 0
        contentView.addSubview(emailLabel)
        
        addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.numberOfLines = 0
        contentView.addSubview(addressLabel)
        
        phoneLabel = UILabel()
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.numberOfLines = 0
        contentView.addSubview(phoneLabel)
        
        websiteLabel = UILabel()
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteLabel.numberOfLines = 0
        contentView.addSubview(websiteLabel)
        
        companyLabel = UILabel()
        companyLabel.translatesAutoresizingMaskIntoConstraints = false
        companyLabel.numberOfLines = 0
        contentView.addSubview(companyLabel)
        
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mapView)
        
        logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .systemRed
        logoutButton.layer.cornerRadius = 8
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoutButton)
        
        setupConstraints()
        configureView()
        loadUserFromUserDefaults()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            buttonsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50),
            
            scrollView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            addressLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
            phoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            websiteLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 10),
            websiteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            websiteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            companyLabel.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 10),
            companyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            companyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            mapView.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mapView.heightAnchor.constraint(equalToConstant: 200),
            
            logoutButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    func configureView() {
        guard let user = user else {
            print("User is nil")
            return
        }
        
        nameLabel.text = "Name: \(user.name)"
        usernameLabel.text = "Username: \(user.username)"
        emailLabel.text = "Email: \(user.email)"
        addressLabel.text = "Address: \(user.address.street), \(user.address.suite), \(user.address.city), \(user.address.zipcode)"
        phoneLabel.text = "Phone: \(user.phone)"
        websiteLabel.text = "Website: \(user.website)"
        companyLabel.text = "Company: \(user.company.name), \(user.company.catchPhrase), \(user.company.bs)"
        
        if let lat = Double(user.address.geo.lat), let lng = Double(user.address.geo.lng) {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    @objc func logoutButtonTapped() {
        UserDefaults.standard.removeObject(forKey: "loggedInUser")
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true, completion: nil)
    }
    
    @objc func showOrders() {
        let ordersVC = MyOrdersViewController()
        navigationController?.pushViewController(ordersVC, animated: true)
    }
    
    @objc func showSavedAddresses() {
        let savedAddressesVC = SavedAddressesViewController()
        savedAddressesVC.previousScreen = .profile
        navigationController?.pushViewController(savedAddressesVC, animated: true)
    }

    @objc func showSavedCards() {
        let savedCardsVC = SavedCardsViewController()
        savedCardsVC.previousScreen = .profile
        navigationController?.pushViewController(savedCardsVC, animated: true)
    }
    
    func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "ButtonColor")
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func loadUserFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "loggedInUser"),
           let savedUser = try? JSONDecoder().decode(User.self, from: data) {
            self.user = savedUser
        } else {
            print("Failed to load user from UserDefaults")
        }
    }

}
