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
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
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
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userImageView.widthAnchor.constraint(equalToConstant: 40),
            userImageView.heightAnchor.constraint(equalToConstant: 40),

            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            userEmailLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            userEmailLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),

            userDateLabel.topAnchor.constraint(equalTo: userEmailLabel.bottomAnchor, constant: 5),
            userDateLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            userDateLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            userDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
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

