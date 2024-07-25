//
//  AdressCell.swift
//  tsoftInternshipProject
//
//  Created by Mehmet Tırpan on 19.07.2024.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    private let addressLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addressLabel.numberOfLines = 0
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    func configure(with address: SavedAddress) {
        addressLabel.text = address.addressDetails
    }
}
