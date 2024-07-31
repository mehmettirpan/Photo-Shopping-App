//
//  MyOrderViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 19.07.2024.
//

import UIKit
import CoreData

class MyOrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var orders: [Order] = []
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Orders"
        setupUI()
        fetchOrders()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OrderCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func fetchOrders() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "addedDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            orders = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch orders: \(error)")
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        let order = orders[indexPath.row]
        
        let orderInfo = """
        Total: \(order.totalAmount)
        Date: \(formattedDate(from: order.addedDate))
        """
        cell.textLabel?.text = orderInfo
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = orders[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let orderDetailsVC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsVC") as? OrderDetailsViewController else {
            return
        }
        
        // Pass data to OrderDetailsViewController
        orderDetailsVC.order = order
        tableView.deselectRow(at: indexPath, animated: true) // seçilen öğenin arkaplanın seçili kalmamasını sağlar
        navigationController?.pushViewController(orderDetailsVC, animated: true)
    }
    
    // Helper function to format date
    private func formattedDate(from date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
