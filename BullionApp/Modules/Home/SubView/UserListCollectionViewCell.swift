//
//  UserListCollectionViewCell.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 14/06/24.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    let userImageView = UIImageView()
    let userNameLabel = UILabel()
    let userEmailLabel = UILabel()
    let userDateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4

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
        userDateLabel.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(userDateLabel)

        NSLayoutConstraint.activate([
            userImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            userImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            userImageView.widthAnchor.constraint(equalToConstant: 40),
            userImageView.heightAnchor.constraint(equalToConstant: 40),

            userNameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 3),
            userEmailLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            userEmailLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),

            userDateLabel.centerYAnchor.constraint(equalTo: self.userImageView.centerYAnchor),
            userDateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
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
