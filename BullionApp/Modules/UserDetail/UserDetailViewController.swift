//
//  UserDetailViewController.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 13/06/24.
//

//
//  UserDetailViewController.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 13/06/24.
//

import UIKit

class UserDetailViewController: UIViewController {
    var userId: String?
    var authToken: String?
    var viewModel = UserDetailViewModel()
    var onDismiss: (() -> Void)?

    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let genderLabel = UILabel()
    let genderText = UILabel()
    let dateOfBirthText = UILabel()
    let dateOfBirthLabel = UILabel()
    let addressText = UILabel()
    let addressLabel = UILabel()
    let imageView = UIImageView()
    let phoneText = UILabel()
    let phoneLabel = UILabel()
    let closeButton = UIButton()
    var editUserButton: UIButton!
    var deleteUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.authToken = authToken
        setupView()
        fetchData()
    }
    
    @objc func editUserButtonTapped(_ sender: Any) {
        let editVC = EditUserViewController()
        editVC.userId = userId
        editVC.authToken = authToken
        editVC.modalPresentationStyle = .formSheet
        editVC.onUserUpdated = { [weak self] in
            self?.fetchData()
        }
        present(editVC, animated: true, completion: nil)
    }
    
    @objc func deleteUserButtonTapped(_ sender: Any) {
        viewModel.deleteUser(userId: userId ?? "") { [weak self] success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    let alert = UIAlertController(title: "Success", message: "User successfully deleted", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
    
                } else {
                    let alert = UIAlertController(title: "Error", message: errorMessage ?? "Failed to delete user", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
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
        
        phoneText.text = "Phone"
        phoneText.translatesAutoresizingMaskIntoConstraints = false
        phoneText.font = UIFont.preferredFont(forTextStyle: .caption1)
        phoneText.textColor = .gray
        view.addSubview(phoneText)
        
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(phoneLabel)
        
        addressText.text = "Address"
        addressText.translatesAutoresizingMaskIntoConstraints = false
        addressText.font = UIFont.preferredFont(forTextStyle: .caption1)
        addressText.textColor = .gray
        view.addSubview(addressText)
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(addressLabel)
        
        editUserButton = UIButton(type: .system)
        editUserButton.setTitle("Edit User", for: .normal)
        editUserButton.addTarget(self, action: #selector(editUserButtonTapped(_:)), for: .touchUpInside)
        editUserButton.translatesAutoresizingMaskIntoConstraints = false
        editUserButton.backgroundColor = UIColor.customBlue
        editUserButton.layer.cornerRadius = 20
        editUserButton.setTitleColor(.white, for: .normal)
        view.addSubview(editUserButton)
        
        deleteUserButton = UIButton(type: .system)
        deleteUserButton.setTitle("Delete User", for: .normal)
        deleteUserButton.addTarget(self, action: #selector(deleteUserButtonTapped(_:)), for: .touchUpInside)
        deleteUserButton.translatesAutoresizingMaskIntoConstraints = false
        deleteUserButton.backgroundColor = UIColor.red
        deleteUserButton.layer.cornerRadius = 20
        deleteUserButton.setTitleColor(.white, for: .normal)
        view.addSubview(deleteUserButton)
        
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
            
            phoneText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            phoneText.topAnchor.constraint(equalTo: dateOfBirthLabel.bottomAnchor, constant: 10),
            
            phoneLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            phoneLabel.topAnchor.constraint(equalTo: phoneText.bottomAnchor, constant: 3),
            
            addressText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            addressText.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 10),
            
            addressLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            addressLabel.topAnchor.constraint(equalTo: addressText.bottomAnchor, constant: 3),
            
            editUserButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            editUserButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            editUserButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 40),
            editUserButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteUserButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            deleteUserButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            deleteUserButton.topAnchor.constraint(equalTo: editUserButton.bottomAnchor, constant: 20),
            deleteUserButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func fetchData() {
        guard let userId = userId else { return }
        viewModel.fetchUserDetail(userId: userId) { [weak self] success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    self?.configureView()
                } else {
                    self?.showError(message: errorMessage)
                }
            }
        }
    }
    
    private func configureView() {
        guard let userDetail = viewModel.userDetail else { return }
        nameLabel.text = "\(userDetail.firstName) \(userDetail.lastName)"
        emailLabel.text = userDetail.email
        genderLabel.text = userDetail.gender
        addressLabel.text = userDetail.address
        phoneLabel.text = userDetail.phone
        if let image = userDetail.uiImage {
            imageView.image = image
        }
        dateOfBirthLabel.text = formattedDate(from: userDetail.dateOfBirth)
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
    
    private func showError(message: String?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func closeButtonTapped() {
        onDismiss?()
        dismiss(animated: true, completion: nil)
    }
}
