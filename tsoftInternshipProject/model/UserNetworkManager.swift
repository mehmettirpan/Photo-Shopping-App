//
//  UserNetworkManager.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 12.07.2024.
//

import Foundation

class UserNetworkManager {
    static let shared = UserNetworkManager()

    func fetchUsers(completion: @escaping ([User]?) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(users)
            } catch {
                print("Error decoding users: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
