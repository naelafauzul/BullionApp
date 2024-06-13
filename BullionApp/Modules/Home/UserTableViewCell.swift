//
//  UserTableViewCell.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 13/06/24.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    let userImageView = UIImageView()
    let userNameLabel = UILabel()
    let userEmailLabel = UILabel()
    let userDateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        userImageView.image = UIImage(named: "placeholder")
        contentView.addSubview(userImageView)

        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(userNameLabel)

        userEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        userEmailLabel.font = UIFont.systemFont(ofSize: 14)
        userEmailLabel.textColor = .gray
        contentView.addSubview(userEmailLabel)

        userDateLabel.translatesAutoresizingMaskIntoConstraints = false
        userDateLabel.font = UIFont.systemFont(ofSize: 14)
        userDateLabel.textColor = .gray
        contentView.addSubview(userDateLabel)

        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 40),
            userImageView.heightAnchor.constraint(equalToConstant: 40),

            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 15),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            userEmailLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            userEmailLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            userEmailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),

            userDateLabel.topAnchor.constraint(equalTo: userNameLabel.topAnchor),
            userDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }

    func configure(with user: UserList) {
        userNameLabel.text = user.name
        userEmailLabel.text = user.email
        userDateLabel.text = formattedDate(from: user.dateOfBirth)
        if let image = user.uiImage {
            userImageView.image = image
        }
    }

    private func formattedDate(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMM dd, yyyy"
            return formatter.string(from: date)
        }
        return dateString
    }
}
