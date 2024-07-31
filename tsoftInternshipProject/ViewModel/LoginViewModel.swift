//
//  LoginViewModel.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 14.07.2024.
//

import Foundation

class LoginViewModel {
    var users: [User] = []
    var adminUser: User
    
    init() {
        // Initialize the admin user
        adminUser = User(
            id: 0,
            name: "Mehmet Tırpan",
            username: "MehmetTırpan",
            email: "admin@example.com",
            address: Address(
                street: "Main Street",
                suite: "Suite 100",
                city: "Istanbul",
                zipcode: "34000",
                geo: Geo(lat: "41.0082", lng: "28.9784")
//                district: "Fatih"
            ),
            phone: "+90 212 123 45 67",
            website: "www.mehmettirpan.com",
            company: Company(
                name: "Tırpan Tech",
                catchPhrase: "Innovation for Tomorrow",
                bs: "technology"
            )
        )
        fetchUsers {
            print("Users fetched successfully")
        }
    }

    func fetchUsers(completion: @escaping () -> Void) {
        UserNetworkManager.shared.fetchUsers { [weak self] users in
            if let users = users {
                self?.users = users
//                print("Fetched \(users.count) users")
//                for user in users {
//                    print("User: \(user.name) (\(user.username))")
//                }
            }
            completion()
        }
    }

    func saveUserToUserDefaults(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "loggedInUser")
        }
    }

    func getUserFromUserDefaults() -> User? {
        if let savedUserData = UserDefaults.standard.data(forKey: "loggedInUser"),
           let savedUser = try? JSONDecoder().decode(User.self, from: savedUserData) {
            return savedUser
        }
        return nil
    }
}
