//
//  SavedAddressesViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 17.07.2024.
//

import UIKit
import CoreData

protocol SavedAddressesViewControllerDelegate: AnyObject {
    func didSelectAddress(_ address: SavedAddress)
}

class SavedAddressesViewController: UIViewController {
    weak var delegate: SavedAddressesViewControllerDelegate?
    var savedAddresses: [SavedAddress] = []
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "My Saved Addresses"
        
        setupTableView()
        setupAddButton()
        fetchSavedAddresses()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddressTableViewCell.self, forCellReuseIdentifier: "AddressCell")
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func setupAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped() {
        let detailVC = SavedAddressDetailViewController()
        detailVC.isNewAddress = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    private func fetchSavedAddresses() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SavedAddress> = SavedAddress.fetchRequest()
        
        do {
            savedAddresses = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch addresses: \(error)")
        }
    }
}
    extension SavedAddressesViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return savedAddresses.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressTableViewCell
            let address = savedAddresses[indexPath.row]
            
            // Configure the cell with the address details
            cell.configure(with: address)
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let address = savedAddresses[indexPath.row]
            delegate?.didSelectAddress(address)
            navigationController?.popViewController(animated: true)
        }
        
        // Implementing swipe-to-delete functionality
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let addressToDelete = savedAddresses[indexPath.row]
                context.delete(addressToDelete)
                
                do {
                    try context.save()
                    savedAddresses.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } catch {
                    print("Failed to delete address: \(error)")
                }
            }
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    }

