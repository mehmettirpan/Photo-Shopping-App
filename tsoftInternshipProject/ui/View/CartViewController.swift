//
//  AddToCartViewController.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 9.07.2024.
//

import UIKit

class CartViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var viewModel: CartViewModel!
    private var collectionView: UICollectionView!
    private var totalPriceLabel: UILabel!
    private var confirmButton: UIButton!
    private var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CartViewModel.shared
        setupUI()
        reloadCart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadCart()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 40, height: 100)
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CartItemCell.self, forCellWithReuseIdentifier: "CartItemCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        footerView = UIView()
        footerView.backgroundColor = .lightGray
        footerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footerView)
        
        totalPriceLabel = UILabel()
        totalPriceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(totalPriceLabel)
        
        confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm Cart", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .systemGreen
        confirmButton.layer.cornerRadius = 8
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -20),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 60),
            
            confirmButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            confirmButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            confirmButton.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 0.33),
            confirmButton.heightAnchor.constraint(equalToConstant: 40),
            
            totalPriceLabel.leadingAnchor.constraint(equalTo: confirmButton.trailingAnchor, constant: 10),
            totalPriceLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
        ])
        
        confirmButton.addTarget(self, action: #selector(confirmCartButtonTapped), for: .touchUpInside)

    }
    
    @objc private func confirmCartButtonTapped() {
        let paymentVC = PaymentViewController()
        navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    private func reloadCart() {
        collectionView.reloadData()
        totalPriceLabel.text = "Total: $\(String(format: "%.2f", viewModel.totalPrice()))"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
        let item = viewModel.cartItems[indexPath.row]
        cell.configure(with: item, index: indexPath.row, target: self)
        return cell
    }
    
    @objc func increaseQuantity(_ sender: UIButton) {
        let index = sender.tag
        var item = viewModel.cartItems[index]
        item.quantity += 1
        viewModel.updateQuantity(at: index, quantity: item.quantity)
        reloadCart()
    }
    
    @objc func decreaseQuantity(_ sender: UIButton) {
        let index = sender.tag
        var item = viewModel.cartItems[index]
        if item.quantity > 1 {
            item.quantity -= 1
            viewModel.updateQuantity(at: index, quantity: item.quantity)
            reloadCart()
        }
    }
    
    @objc func deleteItem(_ sender: UIButton) {
        let index = sender.tag
        viewModel.removeItem(at: index)
        reloadCart()
    }
}
