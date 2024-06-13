//
//  UserDetailViewController.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 13/06/24.
//

import UIKit

class UserDetailViewController: UIViewController {
    var userDetail: UserDetail?
    
    let userImageView = UIImageView()
    let userNameLabel = UILabel()
    let userEmailLabel = UILabel()
    let userGenderLabel = UILabel()
    let userPhoneLabel = UILabel()
    let userAddressLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = 50
        userImageView.clipsToBounds = true
        view.addSubview(userImageView)
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(userNameLabel)
        
        userEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userEmailLabel)
        
        userGenderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userGenderLabel)
        
        userPhoneLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userPhoneLabel)
        
        userAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        userAddressLabel.numberOfLines = 0
        view.addSubview(userAddressLabel)
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 100),
            userImageView.heightAnchor.constraint(equalToConstant: 100),
            
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10),
            userEmailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userGenderLabel.topAnchor.constraint(equalTo: userEmailLabel.bottomAnchor, constant: 10),
            userGenderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userPhoneLabel.topAnchor.constraint(equalTo: userGenderLabel.bottomAnchor, constant: 10),
            userPhoneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userAddressLabel.topAnchor.constraint(equalTo: userPhoneLabel.bottomAnchor, constant: 10),
            userAddressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userAddressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userAddressLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureView() {
        if let userDetail = userDetail {
            userNameLabel.text = userDetail.name
            userEmailLabel.text = userDetail.email
            userGenderLabel.text = "Gender: \(userDetail.gender.capitalized)"
            userPhoneLabel.text = "Phone: \(userDetail.phone)"
            userAddressLabel.text = "Address: \(userDetail.address)"
            
            if let imageData = Data(base64Encoded: userDetail.photo) {
                userImageView.image = UIImage(data: imageData)
            } else {
                userImageView.image = UIImage(named: "placeholder")
            }
        } 
    }
}
