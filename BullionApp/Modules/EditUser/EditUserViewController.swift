//
//  EditUserViewController.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 14/06/24.
//

import UIKit

class EditUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var userId: String?
    var authToken: String?
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var nameText: UILabel!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var emailText: UILabel!
    var genderText: UILabel!
    var addUserButton: UIButton!
    var logoImageView: UIImageView!
    var backButton: UIButton!
    var dateText: UILabel!
    var dateOfBirthTextField: UITextField!
    var datePicker: UIDatePicker!
    var dateButton: UIButton!
    var phoneText: UILabel!
    var phoneNumberTextField: UITextField!
    var photoText: UILabel!
    var photoProfileTextField: UITextField!
    var photoButton: UIButton!
    var addressText: UILabel!
    var addressTextfield: UITextField!
    
    var maleButton: UIButton!
    var femaleButton: UIButton!
    
    var selectedPhoto: UIImage?
    
    var viewModel = UserDetailViewModel()
    
    var onUserUpdated: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.customOrange
        
        setupView()
        setupBindings()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func genderButtonTapped(_ sender: UIButton) {
        maleButton.isSelected = sender == maleButton
        femaleButton.isSelected = sender == femaleButton
        updateGenderButtons()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateOfBirthTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func dateButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Date of Birth", message: nil, preferredStyle: .actionSheet)
        
        let pickerFrame = CGRect(x: 0, y: 0, width: alertController.view.bounds.width, height: 216)
        datePicker = UIDatePicker(frame: pickerFrame)
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        alertController.view.addSubview(datePicker)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.dateOfBirthTextField.text = dateFormatter.string(from: self.datePicker.date)
        }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func photoButtonTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            photoProfileTextField.text = imageUrl.lastPathComponent
            selectedPhoto = pickedImage

        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addUserButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let dateOfBirth = dateOfBirthTextField.text, !dateOfBirth.isEmpty,
              let phone = phoneNumberTextField.text, !phone.isEmpty,
              let address = addressTextfield.text, !address.isEmpty,
              let gender = maleButton.isSelected ? "male" : femaleButton.isSelected ? "female" : nil else {
            showAlert(message: "All fields must be filled")
            return
        }
        
        let nameComponents = name.split(separator: " ")
        guard nameComponents.count >= 2 else {
            showAlert(message: "Please enter both first name and last name")
            return
        }
        
        let firstName = String(nameComponents.first!)
        let lastName = String(nameComponents.last!)
        
        viewModel.userDetail?.firstName = firstName
        viewModel.userDetail?.lastName = lastName
        viewModel.userDetail?.email = email
        viewModel.userDetail?.gender = gender
        viewModel.userDetail?.dateOfBirth = dateOfBirth
        viewModel.userDetail?.phone = phone
        viewModel.userDetail?.address = address
        
        viewModel.updateUserDetail(userId: userId ?? "") { [weak self] success, errorMessage in
            if success, let image = self?.selectedPhoto {
                self?.viewModel.uploadPhoto(userId: self?.userId ?? "", image: image) { photoSuccess, photoErrorMessage in
                    DispatchQueue.main.async {
                        if photoSuccess {
                            self?.onUserUpdated?()
                            self?.dismiss(animated: true, completion: nil)
                        } else {
                            self?.showAlert(message: photoErrorMessage ?? "Failed to update user photo")
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if success {
                        self?.onUserUpdated?()
                        self?.dismiss(animated: true, completion: nil)
                    } else {
                        self?.showAlert(message: errorMessage ?? "Failed to update user")
                    }
                }
            }
        }
    }
    
    func setupBindings() {
        // Implement bindings if necessary
    }
    
    private func fetchData() {
        guard let userId = userId else { return }
        viewModel.authToken = authToken
        viewModel.fetchUserDetail(userId: userId) { [weak self] success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    self?.configureView()
                } else {
                    self?.showAlert(message: errorMessage ?? "")
                }
            }
        }
    }
    
    private func configureView() {
        guard let userDetail = viewModel.userDetail else { return }
        nameTextField.text = "\(userDetail.firstName) \(userDetail.lastName)"
        emailTextField.text = userDetail.email
        dateOfBirthTextField.text = userDetail.dateOfBirth
        phoneNumberTextField.text = userDetail.phone
        addressTextfield.text = userDetail.address
        maleButton.isSelected = userDetail.gender == "male"
        femaleButton.isSelected = userDetail.gender == "female"
        updateGenderButtons()
        if let image = userDetail.uiImage {
            // Display the selected image if available
        }
    }
    
    func setupView() {
        logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "Logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoImageView)
        
        backButton = UIButton(type: .system)
        let backImage = UIImage(systemName: "chevron.left")
        backButton.setImage(backImage, for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backButton)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.customGray
        backgroundView.layer.cornerRadius = 24
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOpacity = 0.2
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundView.layer.shadowRadius = 4
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundView)
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        nameText = UILabel()
        nameText.text = "Name"
        nameText.textColor = UIColor.customOrange
        nameText.font = UIFont.preferredFont(forTextStyle: .footnote)
        nameText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameText)
        
        nameTextField = UITextField()
        nameTextField.placeholder = "Enter name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.layer.cornerRadius = 20
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.masksToBounds = true
        contentView.addSubview(nameTextField)
        
        genderText = UILabel()
        genderText.text = "Gender"
        genderText.textColor = UIColor.customOrange
        genderText.font = UIFont.preferredFont(forTextStyle: .footnote)
        genderText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genderText)
        
        maleButton = UIButton(type: .system)
        maleButton.setTitle("Male", for: .normal)
        maleButton.tintColor = .customOrange
        maleButton.layer.borderColor = UIColor.customOrange.cgColor
        maleButton.layer.borderWidth = 1
        maleButton.layer.cornerRadius = 5
        maleButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(maleButton)
        
        femaleButton = UIButton(type: .system)
        femaleButton.setTitle("Female", for: .normal)
        femaleButton.tintColor = .customOrange
        femaleButton.layer.borderColor = UIColor.customOrange.cgColor
        femaleButton.layer.borderWidth = 1
        femaleButton.layer.cornerRadius = 5
        femaleButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(femaleButton)
        
        dateText = UILabel()
        dateText.text = "Date of Birth"
        dateText.textColor = UIColor.customOrange
        dateText.font = UIFont.preferredFont(forTextStyle: .footnote)
        dateText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateText)
        
        dateOfBirthTextField = UITextField()
        dateOfBirthTextField.placeholder = "Select date of birth"
        dateOfBirthTextField.borderStyle = .roundedRect
        dateOfBirthTextField.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirthTextField.layer.cornerRadius = 20
        dateOfBirthTextField.layer.borderWidth = 1
        dateOfBirthTextField.layer.borderColor = UIColor.lightGray.cgColor
        dateOfBirthTextField.layer.masksToBounds = true
        contentView.addSubview(dateOfBirthTextField)
        
        dateButton = UIButton(type: .system)
        dateButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        dateButton.tintColor = .black
        dateButton.addTarget(self, action: #selector(dateButtonTapped(_:)), for: .touchUpInside)
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateButton)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        dateOfBirthTextField.inputView = datePicker
        
        emailText = UILabel()
        emailText.text = "Email"
        emailText.textColor = UIColor.customOrange
        emailText.font = UIFont.preferredFont(forTextStyle: .footnote)
        emailText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailText)
        
        emailTextField = UITextField()
        emailTextField.placeholder = "Enter email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.layer.cornerRadius = 20
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.masksToBounds = true
        contentView.addSubview(emailTextField)
        
        phoneText = UILabel()
        phoneText.text = "Phone Number"
        phoneText.textColor = UIColor.customOrange
        phoneText.font = UIFont.preferredFont(forTextStyle: .footnote)
        phoneText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(phoneText)
        
        phoneNumberTextField = UITextField()
        phoneNumberTextField.placeholder = "Enter phone number"
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextField.layer.cornerRadius = 20
        phoneNumberTextField.layer.borderWidth = 1
        phoneNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberTextField.layer.masksToBounds = true
        contentView.addSubview(phoneNumberTextField)
        
        addressText = UILabel()
        addressText.text = "Address"
        addressText.textColor = UIColor.customOrange
        addressText.font = UIFont.preferredFont(forTextStyle: .footnote)
        addressText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addressText)
        
        addressTextfield = UITextField()
        addressTextfield.placeholder = "Enter address"
        addressTextfield.borderStyle = .roundedRect
        addressTextfield.translatesAutoresizingMaskIntoConstraints = false
        addressTextfield.layer.cornerRadius = 20
        addressTextfield.layer.borderWidth = 1
        addressTextfield.layer.borderColor = UIColor.lightGray.cgColor
        addressTextfield.layer.masksToBounds = true
        contentView.addSubview(addressTextfield)
        
        photoText = UILabel()
        photoText.text = "Profile photo"
        photoText.textColor = UIColor.customOrange
        photoText.font = UIFont.preferredFont(forTextStyle: .footnote)
        photoText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoText)
        
        photoProfileTextField = UITextField()
        photoProfileTextField.placeholder = "Select photo profile"
        photoProfileTextField.borderStyle = .roundedRect
        photoProfileTextField.translatesAutoresizingMaskIntoConstraints = false
        photoProfileTextField.layer.cornerRadius = 20
        photoProfileTextField.layer.borderWidth = 1
        photoProfileTextField.layer.borderColor = UIColor.lightGray.cgColor
        photoProfileTextField.layer.masksToBounds = true
        contentView.addSubview(photoProfileTextField)
        
        photoButton = UIButton(type: .system)
        photoButton.setImage(UIImage(systemName: "link"), for: .normal)
        photoButton.addTarget(self, action: #selector(photoButtonTapped(_:)), for: .touchUpInside)
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoButton)
        
        addUserButton = UIButton(type: .system)
        addUserButton.setTitle("Update User", for: .normal)
        addUserButton.translatesAutoresizingMaskIntoConstraints = false
        addUserButton.backgroundColor = UIColor.customBlue
        addUserButton.layer.cornerRadius = 20
        addUserButton.setTitleColor(.white, for: .normal)
        addUserButton.addTarget(self, action: #selector(addUserButtonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(addUserButton)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.widthAnchor.constraint(equalToConstant: 130),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            backgroundView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            nameText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            nameTextField.leadingAnchor.constraint(equalTo: nameText.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 10),
            nameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            genderText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genderText.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            
            maleButton.leadingAnchor.constraint(equalTo: genderText.leadingAnchor),
            maleButton.topAnchor.constraint(equalTo: genderText.bottomAnchor, constant: 10),
            maleButton.widthAnchor.constraint(equalToConstant: 100),
            maleButton.heightAnchor.constraint(equalToConstant: 40),
            
            femaleButton.leadingAnchor.constraint(equalTo: maleButton.trailingAnchor, constant: 20),
            femaleButton.topAnchor.constraint(equalTo: genderText.bottomAnchor, constant: 10),
            femaleButton.widthAnchor.constraint(equalToConstant: 100),
            femaleButton.heightAnchor.constraint(equalToConstant: 40),
            
            dateText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateText.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: 20),
            
            dateOfBirthTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateOfBirthTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateOfBirthTextField.topAnchor.constraint(equalTo: dateText.bottomAnchor, constant: 10),
            dateOfBirthTextField.heightAnchor.constraint(equalToConstant: 48),
            
            dateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            dateButton.centerYAnchor.constraint(equalTo: dateOfBirthTextField.centerYAnchor),
            dateButton.heightAnchor.constraint(equalToConstant: 48),
            dateButton.widthAnchor.constraint(equalToConstant: 48),
            
            emailText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailText.topAnchor.constraint(equalTo: dateOfBirthTextField.bottomAnchor, constant: 20),
            
            emailTextField.leadingAnchor.constraint(equalTo: emailText.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.topAnchor.constraint(equalTo: emailText.bottomAnchor, constant: 10),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            
            phoneText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneText.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            
            phoneNumberTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            phoneNumberTextField.topAnchor.constraint(equalTo: phoneText.bottomAnchor, constant: 10),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 48),
            
            addressText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressText.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 20),
            
            addressTextfield.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressTextfield.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addressTextfield.topAnchor.constraint(equalTo: addressText.bottomAnchor, constant: 10),
            addressTextfield.heightAnchor.constraint(equalToConstant: 48),
            
            photoText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photoText.topAnchor.constraint(equalTo: addressTextfield.bottomAnchor, constant: 20),
            
            photoProfileTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photoProfileTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            photoProfileTextField.topAnchor.constraint(equalTo: photoText.bottomAnchor, constant: 10),
            photoProfileTextField.heightAnchor.constraint(equalToConstant: 48),
            
            photoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            photoButton.centerYAnchor.constraint(equalTo: photoProfileTextField.centerYAnchor),
            photoButton.heightAnchor.constraint(equalToConstant: 48),
            
            addUserButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addUserButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addUserButton.topAnchor.constraint(equalTo: photoProfileTextField.bottomAnchor, constant: 20),
            addUserButton.heightAnchor.constraint(equalToConstant: 50),
            addUserButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    func updateGenderButtons() {
        let maleImage = maleButton.isSelected ? UIImage(named: "checked") : UIImage(named: "unchecked")
        maleButton.setImage(maleImage, for: .normal)
        maleButton.backgroundColor = maleButton.isSelected ? .customOrange : .clear
        
        let femaleImage = femaleButton.isSelected ? UIImage(named: "checked") : UIImage(named: "unchecked")
        femaleButton.setImage(femaleImage, for: .normal)
        femaleButton.backgroundColor = femaleButton.isSelected ? .customOrange : .clear
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
