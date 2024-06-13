//
//  ViewController.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 12/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    var emailTextField: UITextField!
    var loginButton: UIButton!
    var emailText: UILabel!
    var passwordTextField: UITextField!
    var passwordText: UILabel!
    var addUserButton: UIButton!
    var logoImageView: UIImageView!
    
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orange
        
        setupBackgroundRectangle()
        setupTextFieldStyles()
        setupButton()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Email dan password harus diisi")
            return
        }
        
        viewModel.email = email
        viewModel.password = password
        viewModel.login()
    }
    
    @objc func addUserButtonTapped(_ sender: Any) {
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func setupBindings() {
        viewModel.onLoginSuccess = { [weak self] user in
            DispatchQueue.main.async {
                let homeVC = HomeViewController()
                homeVC.authToken = user.token
                // Navigasi ke HomeViewController menggunakan UINavigationController
                if let navigationController = self?.navigationController {
                    navigationController.pushViewController(homeVC, animated: true)
                }
            }
        }

        viewModel.onLoginError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
            }
        }
    }

    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupBackgroundRectangle() {
        logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "Logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoImageView)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        backgroundView.layer.cornerRadius = 24
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOpacity = 0.2
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundView.layer.shadowRadius = 4
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundView)
        
        emailText = UILabel()
        emailText.text = "Email"
        emailText.textColor = UIColor.orange
        emailText.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(emailText)
        
        emailTextField = UITextField()
        emailTextField.placeholder = "Enter email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(emailTextField)
        
        passwordText = UILabel()
        passwordText.text = "Password"
        passwordText.textColor = UIColor.orange
        passwordText.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(passwordText)
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Enter password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(passwordTextField)
        
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = UIColor.blue
        backgroundView.addSubview(loginButton)
        
        addUserButton = UIButton(type: .system)
        addUserButton.setTitle("Add User", for: .normal)
        addUserButton.addTarget(self, action: #selector(addUserButtonTapped(_:)), for: .touchUpInside)
        addUserButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(addUserButton)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            backgroundView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        NSLayoutConstraint.activate([
            emailText.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            emailText.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            
            emailTextField.leadingAnchor.constraint(equalTo: emailText.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            emailTextField.topAnchor.constraint(equalTo: emailText.bottomAnchor, constant: 10),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            
            passwordText.leadingAnchor.constraint(equalTo: emailText.leadingAnchor),
            passwordText.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            
            passwordTextField.leadingAnchor.constraint(equalTo: passwordText.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            passwordTextField.topAnchor.constraint(equalTo: passwordText.bottomAnchor, constant: 10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            addUserButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            addUserButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            addUserButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -40),
            addUserButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    func setupTextFieldStyles() {
        emailTextField.layer.cornerRadius = 20
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.masksToBounds = true
        
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.masksToBounds = true
    }
    
    func setupButton() {
        loginButton.backgroundColor = UIColor.customBlue
        loginButton.layer.cornerRadius = 20
        loginButton.setTitleColor(.white, for: .normal)
        
        addUserButton.backgroundColor = UIColor.customBlue
        addUserButton.layer.cornerRadius = 20
        addUserButton.setTitleColor(.white, for: .normal)
    }
    
}
