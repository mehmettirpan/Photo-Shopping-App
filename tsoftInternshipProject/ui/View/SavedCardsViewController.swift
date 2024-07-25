//
//  SavedCardsViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 17.07.2024.
//

import UIKit
import CoreData

protocol SavedCardsViewControllerDelegate: AnyObject {
    func didSelectCard(_ card: Card)
}

class SavedCardsViewController: UIViewController {
    weak var delegate: SavedCardsViewControllerDelegate?
    var savedCards: [Card] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "My Saved Cards"
        
        // Set up the table view
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CardCell")
        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        fetchSavedCards()
    }
    
    private func fetchSavedCards() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        
        do {
            savedCards = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch cards: \(error)")
        }
    }
    
    private func formatCardNumber(_ cardNumber: String) -> String {
        let firstTwo = cardNumber.prefix(2)
        let lastTwo = cardNumber.suffix(2)
        let masked = String(repeating: "*", count: cardNumber.count - 4)
        return "\(firstTwo)\(masked)\(lastTwo)"
    }
}

extension SavedCardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath)
        let card = savedCards[indexPath.row]
        
        if let cardNumber = card.cardNumber {
            cell.textLabel?.text = formatCardNumber(cardNumber)
        } else {
            cell.textLabel?.text = "****"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = savedCards[indexPath.row]
        delegate?.didSelectCard(card)
        navigationController?.popViewController(animated: true)
    }
    
    // Implementing swipe-to-delete functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let cardToDelete = savedCards[indexPath.row]
            context.delete(cardToDelete)
            
            do {
                try context.save()
                savedCards.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Failed to delete card: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
