//
//  RegisterViewController.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 12/06/24.
//

import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var nameText: UILabel!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var emailText: UILabel!
    var passwordTextField: UITextField!
    var confirmPasswordTextField: UITextField!
    var passwordText: UILabel!
    var confirmPasswordText: UILabel!
    var genderText: UILabel!
    var addUserButton: UIButton!
    var logoImageView: UIImageView!
    var backButton: UIButton!
    var dateOfBirthTextField: UITextField!
    var datePicker: UIDatePicker!
    var dateButton: UIButton!
    var phoneNumberTextField: UITextField!
    var photoProfileTextField: UITextField!
    var photoButton: UIButton!
    var addressTextfield: UITextField!
    
    var maleButton: UIButton!
    var femaleButton: UIButton!
    
    var selectedPhoto: UIImage?
    
    var viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orange
        
        setupView()
        setupBindings()
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
        dateOfBirthTextField.becomeFirstResponder()
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
                viewModel.photo = pickedImage // Set the selected photo in the view model
            }
            dismiss(animated: true, completion: nil)
        }
    
    
    @objc func addUserButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty,
              let dateOfBirth = dateOfBirthTextField.text, !dateOfBirth.isEmpty,
              let phone = phoneNumberTextField.text, !phone.isEmpty,
              let address = addressTextfield.text, !address.isEmpty,
                let gender = maleButton.isSelected ? "male" : femaleButton.isSelected ? "female" : nil else {
            showAlert(message: "All fields must be filled")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match")
            return
        }
        
        let nameComponents = name.split(separator: " ")
        guard nameComponents.count >= 2 else {
            showAlert(message: "Please enter both first name and last name")
            return
        }
        
        let firstName = String(nameComponents.first!)
        let lastName = String(nameComponents.last!)
        
        viewModel.firstName = firstName
        viewModel.lastName = lastName
        viewModel.email = email
        viewModel.password = password
        viewModel.gender = gender
        viewModel.dateOfBirth = dateOfBirth
        viewModel.phone = phone
        viewModel.address = address
        
        viewModel.registerUser()
    }
    
    func setupBindings() {
        viewModel.onRegisterSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(message: "Registration successful")
            }
        }
        
        viewModel.onRegisterError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
                print(errorMessage)
            }
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
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backButton)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
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
        
        // Set constraints for scroll view and content view
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Ensure content view width is same as scroll view
        ])
        
        nameText = UILabel()
        nameText.text = "Name"
        nameText.textColor = UIColor.orange
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
        genderText.textColor = UIColor.orange
        genderText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genderText)
        
        maleButton = UIButton(type: .system)
        maleButton.setTitle(" Male", for: .normal)
        maleButton.tintColor = .orange
        maleButton.layer.borderColor = UIColor.orange.cgColor
        maleButton.layer.borderWidth = 1
        maleButton.layer.cornerRadius = 5
        maleButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(maleButton)
        
        femaleButton = UIButton(type: .system)
        femaleButton.setTitle(" Female", for: .normal)
        femaleButton.tintColor = .orange
        femaleButton.layer.borderColor = UIColor.orange.cgColor
        femaleButton.layer.borderWidth = 1
        femaleButton.layer.cornerRadius = 5
        femaleButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(femaleButton)
        
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
        dateButton.addTarget(self, action: #selector(dateButtonTapped(_:)), for: .touchUpInside)
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateButton)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        dateOfBirthTextField.inputView = datePicker
        
        emailText = UILabel()
        emailText.text = "Email"
        emailText.textColor = UIColor.orange
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
        
        phoneNumberTextField = UITextField()
        phoneNumberTextField.placeholder = "Enter phone number"
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextField.layer.cornerRadius = 20
        phoneNumberTextField.layer.borderWidth = 1
        phoneNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberTextField.layer.masksToBounds = true
        contentView.addSubview(phoneNumberTextField)
        
        addressTextfield = UITextField()
        addressTextfield.placeholder = "Enter address"
        addressTextfield.borderStyle = .roundedRect
        addressTextfield.translatesAutoresizingMaskIntoConstraints = false
        addressTextfield.layer.cornerRadius = 20
        addressTextfield.layer.borderWidth = 1
        addressTextfield.layer.borderColor = UIColor.lightGray.cgColor
        addressTextfield.layer.masksToBounds = true
        contentView.addSubview(addressTextfield)
        
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
        photoButton.setTitle("Browse", for: .normal)
        photoButton.addTarget(self, action: #selector(photoButtonTapped(_:)), for: .touchUpInside)
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoButton)
        
        passwordText = UILabel()
        passwordText.text = "Password"
        passwordText.textColor = UIColor.orange
        passwordText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwordText)
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Enter password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.masksToBounds = true
        passwordTextField.isSecureTextEntry = true
        contentView.addSubview(passwordTextField)
        
        confirmPasswordText = UILabel()
        confirmPasswordText.text = "Confirm Password"
        confirmPasswordText.textColor = UIColor.orange
        confirmPasswordText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(confirmPasswordText)
        
        confirmPasswordTextField = UITextField()
        confirmPasswordTextField.placeholder = "Enter password again"
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.layer.cornerRadius = 20
        confirmPasswordTextField.layer.borderWidth = 1
        confirmPasswordTextField.layer.borderColor = UIColor.lightGray.cgColor
        confirmPasswordTextField.layer.masksToBounds = true
        confirmPasswordTextField.isSecureTextEntry = true
        contentView.addSubview(confirmPasswordTextField)
        
        
        addUserButton = UIButton(type: .system)
        addUserButton.setTitle("Add User", for: .normal)
        addUserButton.translatesAutoresizingMaskIntoConstraints = false
        addUserButton.backgroundColor = UIColor.blue
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
            
            dateOfBirthTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateOfBirthTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            dateOfBirthTextField.topAnchor.constraint(equalTo: femaleButton.bottomAnchor, constant: 20),
            dateOfBirthTextField.heightAnchor.constraint(equalToConstant: 48),
            
            dateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateButton.centerYAnchor.constraint(equalTo: dateOfBirthTextField.centerYAnchor),
            dateButton.heightAnchor.constraint(equalToConstant: 48),
            dateButton.widthAnchor.constraint(equalToConstant: 48),
            
            emailText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailText.topAnchor.constraint(equalTo: dateOfBirthTextField.bottomAnchor, constant: 20),
            
            emailTextField.leadingAnchor.constraint(equalTo: emailText.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.topAnchor.constraint(equalTo: emailText.bottomAnchor, constant: 10),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            
            phoneNumberTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            phoneNumberTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 48),
            
            addressTextfield.leadingAnchor.constraint(equalTo: phoneNumberTextField.leadingAnchor),
            addressTextfield.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addressTextfield.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 10),
            addressTextfield.heightAnchor.constraint(equalToConstant: 48),
            
            photoProfileTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photoProfileTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            photoProfileTextField.topAnchor.constraint(equalTo: addressTextfield.bottomAnchor, constant: 20),
            photoProfileTextField.heightAnchor.constraint(equalToConstant: 48),
            
            photoButton.leadingAnchor.constraint(equalTo: photoProfileTextField.trailingAnchor, constant: 10),
            photoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            photoButton.centerYAnchor.constraint(equalTo: photoProfileTextField.centerYAnchor),
            photoButton.heightAnchor.constraint(equalToConstant: 48),
            
            passwordText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordText.topAnchor.constraint(equalTo: photoProfileTextField.bottomAnchor, constant: 20),
            
            passwordTextField.leadingAnchor.constraint(equalTo: passwordText.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordTextField.topAnchor.constraint(equalTo: passwordText.bottomAnchor, constant: 10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            confirmPasswordText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            confirmPasswordText.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: confirmPasswordText.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordText.bottomAnchor, constant: 10),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            addUserButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addUserButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addUserButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 20),
            addUserButton.heightAnchor.constraint(equalToConstant: 50),
            addUserButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    func updateGenderButtons() {
        let maleImage = maleButton.isSelected ? UIImage(named: "checked") : UIImage(named: "unchecked")
        maleButton.setImage(maleImage, for: .normal)
        maleButton.backgroundColor = maleButton.isSelected ? .orange : .clear
        
        let femaleImage = femaleButton.isSelected ? UIImage(named: "checked") : UIImage(named: "unchecked")
        femaleButton.setImage(femaleImage, for: .normal)
        femaleButton.backgroundColor = femaleButton.isSelected ? .orange : .clear
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
