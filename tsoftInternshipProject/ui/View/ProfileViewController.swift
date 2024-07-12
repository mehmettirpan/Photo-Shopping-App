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
    var usernameLabel: UILabel!
    var emailLabel: UILabel!
    var addressLabel: UILabel!
    var phoneLabel: UILabel!
    var websiteLabel: UILabel!
    var companyLabel: UILabel!
    var mapView: MKMapView!
    var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.systemBackground
        
        print(user?.name as Any) // Debug için user'ı yazdır

        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        self.view.addSubview(nameLabel)
        
        usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.numberOfLines = 0
        self.view.addSubview(usernameLabel)
        
        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.numberOfLines = 0
        self.view.addSubview(emailLabel)
        
        addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.numberOfLines = 0
        self.view.addSubview(addressLabel)
        
        phoneLabel = UILabel()
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.numberOfLines = 0
        self.view.addSubview(phoneLabel)
        
        websiteLabel = UILabel()
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteLabel.numberOfLines = 0
        self.view.addSubview(websiteLabel)
        
        companyLabel = UILabel()
        companyLabel.translatesAutoresizingMaskIntoConstraints = false
        companyLabel.numberOfLines = 0
        self.view.addSubview(companyLabel)
        
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        
        logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoutButton)
        
        setupConstraints()
        configureView()
        loadUserFromUserDefaults()

    }

    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            usernameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            addressLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            addressLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
            phoneLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            phoneLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            websiteLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 10),
            websiteLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            websiteLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            companyLabel.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 10),
            companyLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            companyLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            mapView.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            mapView.heightAnchor.constraint(equalToConstant: 200),
            
            logoutButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
            logoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadUserFromUserDefaults() {
        if let savedUserData = UserDefaults.standard.object(forKey: "loggedInUser") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(User.self, from: savedUserData) {
                self.user = loadedUser
            } else {
                print("Failed to decode user from UserDefaults")
            }
        } else {
            print("No user found in UserDefaults")
        }
    }
    
}
