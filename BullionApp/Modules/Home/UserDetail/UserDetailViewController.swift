//
//  UserDetailViewController.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 13/06/24.
//
import UIKit

class UserDetailViewController: UIViewController {
    var userDetail: UserList?
    
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let genderLabel = UILabel()
    let genderText = UILabel()
    let dateOfBirthText = UILabel()
    let dateOfBirthLabel = UILabel()
    let addressText = UILabel()
    let addressLabel = UILabel()
    let imageView = UIImageView()
    let closeButton = UIButton()
    let editUserButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        configureView()
    }
    
    private func setupView() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(imageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        view.addSubview(nameLabel)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.font = UIFont.systemFont(ofSize: 18)
        emailLabel.textColor = .gray
        view.addSubview(emailLabel)
        
        genderText.text = "Gender"
        genderText.translatesAutoresizingMaskIntoConstraints = false
        genderText.font = UIFont.preferredFont(forTextStyle: .caption1)
        genderText.textColor = .gray
        view.addSubview(genderText)
        
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(genderLabel)
        
        dateOfBirthText.text = "Date of Birth"
        dateOfBirthText.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirthText.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateOfBirthText.textColor = .gray
        view.addSubview(dateOfBirthText)
        
        dateOfBirthLabel.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirthLabel.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(dateOfBirthLabel)
        
        addressText.text = "Address"
        addressText.translatesAutoresizingMaskIntoConstraints = false
        addressText.font = UIFont.preferredFont(forTextStyle: .caption1)
        addressText.textColor = .gray
        view.addSubview(addressText)
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(addressLabel)

        editUserButton.setTitle("Edit User", for: .normal)
        editUserButton.translatesAutoresizingMaskIntoConstraints = false
        editUserButton.backgroundColor = UIColor.customBlue
        editUserButton.layer.cornerRadius = 20
        editUserButton.setTitleColor(.white, for: .normal)
        view.addSubview(editUserButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            
            genderText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            genderText.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            
            genderLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            genderLabel.topAnchor.constraint(equalTo: genderText.bottomAnchor, constant: 3),
            
            dateOfBirthText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            dateOfBirthText.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10),
            
            dateOfBirthLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            dateOfBirthLabel.topAnchor.constraint(equalTo: dateOfBirthText.bottomAnchor, constant: 3),
            
            addressText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            addressText.topAnchor.constraint(equalTo: dateOfBirthLabel.bottomAnchor, constant: 10),
            
            addressLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            addressLabel.topAnchor.constraint(equalTo: addressText.bottomAnchor, constant: 3),
            
            editUserButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            editUserButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            editUserButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20),
            editUserButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    private func configureView() {
        guard let userDetail = userDetail else { return }
        nameLabel.text = userDetail.name
        emailLabel.text = userDetail.email
        genderLabel.text = userDetail.gender
        addressLabel.text = userDetail.address
        dateOfBirthLabel.text = formattedDate(from: userDetail.dateOfBirth)
        if let image = userDetail.uiImage {
            imageView.image = image
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
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func imageTapped() {
        guard let image = imageView.image else { return }
        let fullScreenImageVC = FullScreenImageViewController()
        fullScreenImageVC.image = image
        present(fullScreenImageVC, animated: true, completion: nil)
    }
}

